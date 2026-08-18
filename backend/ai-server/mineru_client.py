"""MinerU 文档解析客户端：文档/图片 → Markdown + 结构化 JSON。

支持两种形态（配置化，config.MINERU_MODE 切换）：
- selfhosted：自部署 mineru-api（POST /file_parse）
- cloud：mineru.net 官方云 API（/api/v4）
"""
from __future__ import annotations

import io
import json
import os
import time
from typing import Any

import httpx

from config import settings

# 图片预处理：低分辨率图片放大后再送 OCR，密集小字（如发票销售方税号）才能被 MinerU 读出来。
# 实测 1349px 宽的发票图，1 倍分辨率 OCR 漏掉销售方纳税人识别号，放大 2 倍后能正确读出。
_IMAGE_EXTS = {'.png', '.jpg', '.jpeg', '.webp', '.bmp', '.tif', '.tiff'}
_UPSCALE_MAX_EDGE = 2400  # 最大边（像素）低于此值才放大
_UPSCALE_FACTOR = 2


def _preprocess_image(file_bytes: bytes, filename: str) -> tuple[bytes, str]:
    """图片放大预处理；非图片或已足够清晰则原样返回。失败时兜底交回 MinerU。"""
    ext = os.path.splitext(filename or '')[1].lower()
    if ext not in _IMAGE_EXTS:
        return file_bytes, filename
    try:
        from PIL import Image
    except ImportError:
        return file_bytes, filename  # 未装 Pillow 则跳过预处理，不阻断主流程
    try:
        img = Image.open(io.BytesIO(file_bytes))
        img.load()
    except Exception:
        return file_bytes, filename
    if max(img.size) >= _UPSCALE_MAX_EDGE:
        return file_bytes, filename
    # 转 RGB（去掉 alpha），LANCZOS 放大保持清晰
    if img.mode in ('RGBA', 'LA', 'P'):
        img = img.convert('RGB')
    up = img.resize((img.width * _UPSCALE_FACTOR, img.height * _UPSCALE_FACTOR), Image.LANCZOS)
    buf = io.BytesIO()
    up.save(buf, format='PNG')
    name, _ = os.path.splitext(filename or '')
    return buf.getvalue(), f'{name}.png'


class MinerUError(Exception):
    pass


class MinerUClient:
    def __init__(self) -> None:
        self.mode = settings.mineru_mode

    @property
    def ready(self) -> bool:
        if self.mode == 'cloud':
            return bool(settings.mineru_cloud_token)
        return True

    def parse(self, file_bytes: bytes, filename: str) -> dict[str, Any]:
        """解析一个文档文件，返回 {'markdown': str, 'middle_json': dict|None}。"""
        file_bytes, filename = _preprocess_image(file_bytes, filename)
        if self.mode == 'selfhosted':
            return self._parse_selfhosted(file_bytes, filename)
        if self.mode == 'cloud':
            return self._parse_cloud(file_bytes, filename)
        raise MinerUError(f'未知的 MINERU_MODE: {self.mode}')

    # ---- 自部署 ----
    def _parse_selfhosted(self, file_bytes: bytes, filename: str) -> dict[str, Any]:
        url = f"{settings.mineru_self_host_url.rstrip('/')}/file_parse"
        with httpx.Client(timeout=300.0) as client:
            resp = client.post(
                url,
                files={'files': (filename, file_bytes)},
                data={
                    'backend': 'pipeline',
                    'return_md': 'true',
                    'return_middle_json': 'true',
                    'lang_list': 'ch',
                },
            )
        if resp.status_code >= 400:
            raise MinerUError(f'MinerU 解析失败: HTTP {resp.status_code} {resp.text[:200]}')
        return self._extract_markdown(resp)

    # ---- 云端（mineru.net /api/v4）----
    def _parse_cloud(self, file_bytes: bytes, filename: str) -> dict[str, Any]:
        if not settings.mineru_cloud_token:
            raise MinerUError('MINERU_CLOUD_TOKEN 未配置')
        base = settings.mineru_cloud_base_url.rstrip('/')
        headers = {'Authorization': f'Bearer {settings.mineru_cloud_token}'}
        with httpx.Client(timeout=300.0) as client:
            # 1) 获取预签名上传 URL
            urls = client.post(f'{base}/file-urls/batch', json={'files': [{'name': filename}]}, headers=headers)
            urls.raise_for_status()
            upload = urls.json()['data']['files'][0]
            # 2) 直传文件到对象存储
            put = client.put(upload['uploadUrl'], content=file_bytes)
            put.raise_for_status()
            # 3) 提交批量解析任务
            task = client.post(f'{base}/extract/task/batch', json={'files': [upload]}, headers=headers)
            task.raise_for_status()
            batch_id = task.json()['data']['batch_id']
            # 4) 轮询结果
            for _ in range(120):
                result = client.get(f'{base}/extract-results/batch/{batch_id}', headers=headers)
                result.raise_for_status()
                data = result.json()['data']
                if data.get('state') in ('done', 'success'):
                    return self._extract_markdown(result)
                time.sleep(2)
        raise MinerUError('MinerU 云端解析超时')

    # ---- 响应解析（对字段名做健壮匹配）----
    @staticmethod
    def _extract_markdown(resp: httpx.Response) -> dict[str, Any]:
        content_type = resp.headers.get('content-type', '')
        if 'application/json' not in content_type:
            # 直接返回了 markdown 文本
            return {'markdown': resp.text, 'middle_json': None}

        data = resp.json()

        # MinerU 2.x 自部署返回：{"backend","version","results":{<文件名>:{md_content,middle_json,...}}}
        # 取第一个文件的结果，同时兼容顶层字段（老版本 / 云端 v4）
        per_file = None
        if isinstance(data, dict) and isinstance(data.get('results'), dict):
            results = data['results']
            per_file = next(iter(results.values()), None) if results else None

        # 提取 markdown（用 is not None 判断，空字符串也是合法结果）
        md = None
        for key in ('full_md', 'md_content', 'markdown', 'content'):
            if isinstance(data, dict) and data.get(key) is not None:
                md = data[key]
                break
        if md is None and isinstance(per_file, dict):
            for key in ('md_content', 'markdown', 'content', 'full_md'):
                if per_file.get(key) is not None:
                    md = per_file[key]
                    break
        if md is None and isinstance(data, str):
            md = data
        if md is None:
            md = resp.text  # 兜底：把原始响应当文本

        # 提取 middle_json（可能是 JSON 字符串）
        middle = data.get('middle_json') if isinstance(data, dict) else None
        if middle is None and isinstance(per_file, dict):
            middle = per_file.get('middle_json') or per_file.get('content_list') or per_file.get('layout')
        if isinstance(middle, str):
            try:
                middle = json.loads(middle)
            except (ValueError, TypeError):
                pass

        return {'markdown': md if isinstance(md, str) else str(md), 'middle_json': middle}


mineru = MinerUClient()
