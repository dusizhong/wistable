"""WisTable Fusion API 客户端封装。

独立 AI 服务通过 Fusion API（Authorization: Bearer usk...）读写表格，
不依赖 WisTable 内部代码。响应统一为 { success, code, message, data } 信封。
"""
from __future__ import annotations

from typing import Any

import httpx

from config import settings


class WisTableError(Exception):
    pass


class WisTableClient:
    def __init__(self) -> None:
        self._client = httpx.Client(
            base_url=settings.wistable_fusion_base_url,
            headers={'Authorization': f'Bearer {settings.wistable_api_token}'},
            timeout=60.0,
        )

    @property
    def ready(self) -> bool:
        return bool(settings.wistable_api_token)

    # ---- 通用 ----
    def _unwrap(self, resp: httpx.Response) -> Any:
        try:
            body = resp.json()
        except ValueError:
            raise WisTableError(f'Fusion API 非 JSON 响应: HTTP {resp.status_code}') from None
        if resp.status_code >= 400 or not body.get('success', True):
            raise WisTableError(f'Fusion API 错误: HTTP {resp.status_code} {body.get("message", body)}')
        return body.get('data')

    # ---- 空间 / 节点 ----
    def list_spaces(self) -> list[dict]:
        data = self._unwrap(self._client.get('/spaces'))
        return data.get('spaces', []) if isinstance(data, dict) else []

    def list_nodes(self, space_id: str, node_type: str = 'Datasheet') -> list[dict]:
        data = self._unwrap(self._client.get(f'/v2/spaces/{space_id}/nodes', params={'type': node_type}))
        return data.get('nodes', []) if isinstance(data, dict) else []

    # ---- 表结构 ----
    def get_fields(self, dst_id: str) -> list[dict]:
        data = self._unwrap(self._client.get(f'/datasheets/{dst_id}/fields'))
        return data.get('fields', []) if isinstance(data, dict) else []

    def get_views(self, dst_id: str) -> list[dict]:
        data = self._unwrap(self._client.get(f'/datasheets/{dst_id}/views'))
        return data.get('views', []) if isinstance(data, dict) else []

    # ---- 记录读写 ----
    def get_records(self, dst_id: str, *, max_records: int = -1, fields: list[str] | None = None,
                    cell_format: str = 'json', field_key: str = 'name') -> list[dict]:
        """拉取记录。max_records=-1 表示不限（用于全量同步 5000+ 行）。"""
        params: dict[str, Any] = {'maxRecords': max_records, 'cellFormat': cell_format, 'fieldKey': field_key}
        if fields:
            params['fields'] = fields
        data = self._unwrap(self._client.get(f'/datasheets/{dst_id}/records', params=params))
        return data.get('records', []) if isinstance(data, dict) else []

    def create_records(self, dst_id: str, records: list[dict], *, field_key: str = 'name') -> list[dict]:
        """新增记录。records 形如 [{ fields: {字段名: 值} }]。单次上限受 API_MAX_MODIFY_RECORD_COUNTS 限制。"""
        data = self._unwrap(self._client.post(
            f'/datasheets/{dst_id}/records', json={'records': records, 'fieldKey': field_key},
        ))
        return data.get('records', []) if isinstance(data, dict) else []

    def update_records(self, dst_id: str, records: list[dict], *, field_key: str = 'name') -> list[dict]:
        """更新记录。records 形如 [{ recordId, fields: {字段名: 值} }]。"""
        data = self._unwrap(self._client.patch(
            f'/datasheets/{dst_id}/records', json={'records': records, 'fieldKey': field_key},
        ))
        return data.get('records', []) if isinstance(data, dict) else []

    def execute_command(self, dst_id: str, command: dict) -> Any:
        """执行任意 CollaCommand（如 AddRecords/SetRecords/AddFields），突破 records 接口的条数上限。"""
        return self._unwrap(self._client.post(f'/datasheets/{dst_id}/executeCommand', json=command))

    # ---- 附件 ----
    def get_presigned_url(self, dst_id: str, count: int = 1) -> list[dict]:
        data = self._unwrap(self._client.get(f'/datasheets/{dst_id}/attachments/presignedUrl', params={'count': count}))
        return data.get('results', []) if isinstance(data, dict) else []

    def close(self) -> None:
        self._client.close()


wis_table = WisTableClient()
