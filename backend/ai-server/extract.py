"""功能①：字段 schema 驱动的信息抽取。

把 MinerU 解析出的文档 Markdown，按目标表的字段定义，用 LLM 结构化抽取为记录，
再做字段类型对齐（Number→数值、SingleSelect→匹配选项名 等），供导入预览/写回。
"""
from __future__ import annotations

import json
import re
from typing import Any

from llm import LLMError, llm

# 单次送入 LLM 的文档文本上限（字符），超长则分块抽取后合并（应对多页投标文件）
# qwen3:8b 上下文 40960 tokens，20k 字符以内可整篇一次抽取，避免切块导致同一实体被拆成多条
_CHUNK_CHARS = 20000
# 一次抽取的字段数上限，超出部分忽略（避免 prompt 过长）
_MAX_FIELDS = 40


def _field_hint(field: dict[str, Any]) -> str:
    """把单个字段描述成给 LLM 看的提示文本。"""
    ftype = field.get('type', 'Text')
    prop = field.get('property') or {}
    name = (field.get('name') or '').strip()
    hint = f"{name}({ftype})"
    if ftype in ('SingleSelect', 'MultiSelect'):
        options = [o.get('name', '') for o in prop.get('options', []) if o.get('name')]
        if options:
            hint += f" 可选值=[{'/'.join(options)}]"
    if field.get('desc'):
        hint += f" 说明={field['desc']}"
    return hint


def build_extract_messages(fields: list[dict[str, Any]], markdown_chunk: str) -> list[dict[str, str]]:
    hints = '\n'.join(_field_hint(f) for f in fields)
    system = (
        '你是文档信息抽取助手。根据给定的字段定义，从文档中抽取信息，'
        '只输出 JSON 对象，形如 {"records": [{"字段名": 值, ...}, ...]}。\n'
        '规则：\n'
        '1. 一条记录 = 文档中一个真实、独立的实体（如一家企业、一张发票、一条明细）。'
        '绝大多数文档只描述一个主体，此时只输出一条记录；只有文档里确实存在多个并列实体时才输出多条。\n'
        '2. 严禁臆造：只抽取文档中明确出现的信息，不得猜测、补全、拆分，'
        '不得生成文档里没有的实体、名称或数值。\n'
        '3. 每个字段值必须能在文档原文中找到对应依据；找不到就省略该字段，'
        '不要填 null、空串或编造的值。\n'
        '4. 字段名与文档标签可能用词不同（如字段「税号」对应文档中的「纳税人识别号」'
        '「统一社会信用代码」），按语义匹配，不要因字面不同就漏掉字段。\n'
        '5. 发票/票据金额三字段必须严格区分、绝不混淆：\n'
        '   「金额」= 不含税金额 / 合计 / 金额合计（税前小计）；\n'
        '   「税额」= 税额（单独一项的税款数值）；\n'
        '   「价税合计」= 含税总额 / 价税合计 / 小写金额（= 金额 + 税额）。\n'
        '   例：文档「合计 ¥334.92」「税额 ￥8.08」「价税合计 ¥343.00」→ 金额=334.92、税额=8.08、价税合计=343.00，'
        '绝不可把 343.00 同时填进「金额」和「价税合计」。\n'
        '6. 仅使用给定的字段名作为 key，不要新增字段。\n'
        '7. SingleSelect 只能填「可选值」之一；MultiSelect 填可选值数组。\n'
        '8. Number/Currency 填纯数字（去掉单位、千分位、货币符号）；Checkbox 填 true/false。'
        '金额数值必须原样保留小数点与小数位：文档写 ¥334.92 就输出 334.92、写 8.08 就输出 8.08，'
        '绝不能去掉小数点写成 33492、808 这类被放大 100 倍的整数。\n'
        '9. 抽取不到任何内容时返回 {"records": []}。\n'
        f'字段定义：\n{hints}'
    )
    user = f'文档内容：\n{markdown_chunk}'
    return [
        {'role': 'system', 'content': system},
        {'role': 'user', 'content': user},
    ]


def _chunks(text: str, size: int = _CHUNK_CHARS) -> list[str]:
    """按换行把超长文本切成多个片段，避免从句子中间截断。"""
    if len(text) <= size:
        return [text]
    parts: list[str] = []
    start = 0
    while start < len(text):
        end = min(start + size, len(text))
        if end < len(text):
            nl = text.rfind('\n', start, end)
            if nl > start + size // 2:
                end = nl
        parts.append(text[start:end])
        start = end
    return parts


def extract_records(fields: list[dict[str, Any]], markdown: str) -> list[dict[str, Any]]:
    """从文档 markdown 抽取记录（未做类型对齐）。字段超上限时截断。"""
    if not llm.ready:
        raise LLMError('LLM_API_KEY 未配置，无法抽取')
    if not markdown.strip():
        return []
    fields = fields[:_MAX_FIELDS]
    records: list[dict[str, Any]] = []
    for chunk in _chunks(markdown):
        result = llm.extract_json(build_extract_messages(fields, chunk))
        if isinstance(result, dict) and isinstance(result.get('records'), list):
            records.extend(r for r in result['records'] if isinstance(r, dict))
    return records


def _to_float(value: Any) -> float | None:
    if isinstance(value, bool):
        return None
    if isinstance(value, (int, float)):
        return float(value)
    if isinstance(value, str):
        cleaned = re.sub(r'[,\s￥¥$€£%元圆]', '', value)
        try:
            return float(cleaned)
        except ValueError:
            return None
    return None


def _to_bool(value: Any) -> bool | None:
    if isinstance(value, bool):
        return value
    if isinstance(value, (int, float)):
        return bool(value)
    if isinstance(value, str):
        return value.strip().lower() in ('true', '1', '是', 'y', 'yes', '√', '✓')
    return None


def _match_option(value: str, options: list[dict[str, Any]]) -> str | None:
    """把抽取值匹配到已有选项名（精确 → 忽略大小写 → 包含）。"""
    names = [o.get('name', '') for o in options if o.get('name')]
    if not names:
        return None
    v = value.strip()
    for n in names:
        if n == v:
            return n
    vl = v.lower()
    for n in names:
        if n.lower() == vl:
            return n
    for n in names:
        if n and (n in value or value in n):
            return n
    return None


def _restore_decimal(value: Any, markdown: str) -> Any:
    """LLM 偶尔会把金额的小数点丢掉（334.92 → 33492）。

    当返回值为整数、且文档中存在「去掉小数点后等于该整数」的小数（如 334.92 去点为 33492）
    时，还原为带小数点的值。仅在整数位数 ≥3 时生效，避免误伤 1~2 位的合法整数。
    """
    if not markdown or value is None:
        return value
    if isinstance(value, bool):
        return value
    try:
        if not float(value).is_integer():
            return value
    except (TypeError, ValueError):
        return value
    int_str = str(int(value))
    if len(int_str) < 3:
        return value
    for m in re.finditer(r'\d+\.\d+', markdown):
        token = m.group(0)
        if token.replace('.', '') == int_str:
            try:
                return float(token)
            except ValueError:
                pass
    return value


def _coerce_one(value: Any, ftype: str, prop: dict[str, Any], markdown: str = '') -> Any:
    if value is None or value == '':
        return None
    if ftype in ('Number', 'Currency', 'Rating', 'AutoNumber'):
        v = _to_float(value)
        return _restore_decimal(v, markdown) if v is not None else None
    if ftype == 'Percent':
        v = _to_float(value)
        return (v / 100 if abs(v) > 1 else v) if v is not None else None
    if ftype == 'Checkbox':
        return _to_bool(value)
    if ftype == 'SingleSelect':
        s = str(value)
        return _match_option(s, prop.get('options', [])) or s
    if ftype == 'MultiSelect':
        items = value if isinstance(value, list) else [value]
        return [(_match_option(str(v), prop.get('options', [])) or str(v)) for v in items]
    # Text / Email / Phone / URL / DateTime / 其它 → 字符串
    if isinstance(value, str):
        return value
    if isinstance(value, (list, dict)):
        return json.dumps(value, ensure_ascii=False)
    return str(value)


def coerce_records(records: list[dict[str, Any]], fields: list[dict[str, Any]], markdown: str = '') -> list[dict[str, Any]]:
    """按字段类型对齐抽取结果，返回可直接写回 Fusion API 的记录列表。

    markdown 用于金额字段的小数点还原（见 _restore_decimal）。
    """
    # 字段名可能带首尾空白（用户建字段时误输入），按去空白后的名字匹配，
    # 写回时仍用字段原名，保证 Fusion API 能命中。
    by_name: dict[str, tuple[str, dict[str, Any]]] = {}
    for f in fields:
        clean = (f.get('name') or '').strip()
        by_name[clean] = (f.get('name') or '', f)
    out: list[dict[str, Any]] = []
    for rec in records:
        row: dict[str, Any] = {}
        for key, value in rec.items():
            entry = by_name.get((key or '').strip())
            if entry is None:
                continue  # 丢弃 LLM 臆造/未知字段
            orig_name, field = entry
            try:
                row[orig_name] = _coerce_one(value, field.get('type', 'Text'), field.get('property') or {}, markdown)
            except Exception:
                row[orig_name] = None
        if any(v is not None for v in row.values()):
            out.append(row)
    return out
