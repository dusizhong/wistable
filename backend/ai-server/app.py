"""WisTable 独立 AI 服务入口（FastAPI）。

可插拔：本服务不启动时，前端 /ai/* 探测失败自动降级，不影响 WisTable 现有功能。
"""
from __future__ import annotations

from typing import Any

from fastapi import FastAPI, File, Form, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

from config import settings
from extract import coerce_records, extract_records
from llm import LLMError
from mineru_client import MinerUError, mineru
from wis_table_client import WisTableError, wis_table

app = FastAPI(title='WisTable AI Service', version='0.1.0')

# 前端通常走 /ai 同源代理（无需 CORS）；此处放开便于独立调试。
app.add_middleware(
    CORSMiddleware,
    allow_origins=['*'],
    allow_methods=['*'],
    allow_headers=['*'],
)

# Fusion API records 接口单次条数上限，超限分片写回
_BATCH = 10


@app.get('/health')
def health() -> dict:
    """可用性探测端点。前端据此决定是否显示 AI 入口。"""
    return {
        'status': 'ok',
        'version': '0.1.0',
        'config': {
            'wistable_ready': settings.wistable_ready,
            'llm_ready': settings.llm_ready,
            'embedding_ready': settings.embedding_ready,
            'mineru_ready': settings.mineru_ready,
            'mineru_mode': settings.mineru_mode,
        },
    }


def _err(message: str) -> dict:
    return {'success': False, 'message': message}


# ---- 功能①：数据智能解析导入 ----


@app.post('/import/parse')
def import_parse(file: UploadFile = File(...), dst_id: str = Form(...), category: str = Form('')) -> dict:
    """上传文档 → MinerU 解析 → 按目标表字段抽取 → 返回预览（不写库）。category 暂仅透传/回显，分类策略后置。"""
    if not mineru.ready:
        return _err('文档解析不可用：MinerU 未配置（MINERU_MODE/MINERU_CLOUD_TOKEN）')
    if not wis_table.ready:
        return _err('无法读取目标表：WISTABLE_API_TOKEN 未配置')
    if not settings.llm_ready:
        return _err('信息抽取不可用：LLM_API_KEY 未配置')

    raw = file.file.read()
    if not raw:
        return _err('上传失败：文件为空')

    try:
        parsed = mineru.parse(raw, file.filename or 'upload')
        markdown = parsed['markdown']
        fields = wis_table.get_fields(dst_id)
        records = extract_records(fields, markdown)
        coerced = coerce_records(records, fields, markdown)
    except (MinerUError, WisTableError, LLMError) as exc:
        return _err(str(exc))
    except Exception as exc:  # noqa: BLE001 — 兜底，避免把堆栈抛给前端
        return _err(f'解析失败: {exc}')

    return {
        'success': True,
        'data': {
            'filename': file.filename,
            'category': category,
            'markdown': markdown[:4000],  # 预览用，截断
            'markdown_length': len(markdown),
            'fields': fields,
            'records': coerced,
            'record_count': len(coerced),
        },
    }


class CommitRequest(BaseModel):
    dst_id: str
    records: list[dict[str, Any]]


@app.post('/import/commit')
def import_commit(req: CommitRequest) -> dict:
    """把用户确认后的记录写回目标表。"""
    if not wis_table.ready:
        return _err('无法写入目标表：WISTABLE_API_TOKEN 未配置')
    if not req.records:
        return _err('没有可导入的记录')

    created: list[dict] = []
    try:
        for i in range(0, len(req.records), _BATCH):
            chunk = [{'fields': r} for r in req.records[i:i + _BATCH]]
            created.extend(wis_table.create_records(req.dst_id, chunk))
    except WisTableError as exc:
        return {'success': False, 'message': str(exc), 'data': {'created': created}}

    return {'success': True, 'data': {'created': created, 'count': len(created)}}


# ---- 功能②：智能问数（阶段 2 实现）----
@app.post('/ask')
def ask() -> dict:
    return {'success': False, 'message': 'not implemented'}
