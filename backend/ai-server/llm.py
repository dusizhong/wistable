"""统一 LLM 接入层：OpenAI 兼容协议（覆盖 GPT / DeepSeek / 通义 / Moonshot 等）。

后续如需 Anthropic Claude，在此追加一个 provider 分支即可，对外接口不变。
未配置 LLM_API_KEY 时模块可正常导入（保证 AI 服务可插拔、可降级），
仅在真正调用时才抛出 LLMError。
"""
from __future__ import annotations

import json
from typing import Any

from openai import OpenAI

from config import settings


class LLMError(Exception):
    pass


class LLMClient:
    """OpenAI 兼容的 LLM 客户端，提供文本对话 / 结构化 JSON / Embedding 三个能力。"""

    def __init__(self) -> None:
        self.model = settings.llm_model
        self._client: OpenAI | None = None
        self._embed_client: OpenAI | None = None

    @property
    def ready(self) -> bool:
        return bool(settings.llm_api_key)

    @property
    def embedding_ready(self) -> bool:
        return bool(settings.embedding_api_key)

    def _get_client(self) -> OpenAI:
        if not settings.llm_api_key:
            raise LLMError('LLM_API_KEY 未配置')
        if self._client is None:
            self._client = OpenAI(base_url=settings.llm_base_url, api_key=settings.llm_api_key)
        return self._client

    def _get_embed_client(self) -> OpenAI:
        if not settings.embedding_api_key:
            raise LLMError('EMBEDDING_API_KEY 未配置')
        if self._embed_client is None:
            self._embed_client = OpenAI(base_url=settings.embedding_base_url, api_key=settings.embedding_api_key)
        return self._embed_client

    def chat(self, messages: list[dict[str, str]], *, temperature: float = 0.2, max_tokens: int | None = None) -> str:
        """非流式对话，返回文本。"""
        kwargs: dict[str, Any] = {'model': self.model, 'messages': messages, 'temperature': temperature}
        if max_tokens:
            kwargs['max_tokens'] = max_tokens
        resp = self._get_client().chat.completions.create(**kwargs)
        return resp.choices[0].message.content or ''

    def extract_json(self, messages: list[dict[str, str]], *, temperature: float = 0.0) -> Any:
        """要求模型输出 JSON 并解析为 Python 对象。失败抛出 LLMError。"""
        resp = self._get_client().chat.completions.create(
            model=self.model,
            messages=messages,
            temperature=temperature,
            response_format={'type': 'json_object'},
        )
        content = resp.choices[0].message.content or ''
        try:
            return json.loads(content)
        except json.JSONDecodeError as exc:
            raise LLMError(f'LLM 未返回合法 JSON: {content[:200]}') from exc

    def embed(self, texts: list[str]) -> list[list[float]]:
        """文本向量化（用于智能问数的语义检索）。"""
        resp = self._get_embed_client().embeddings.create(model=settings.embedding_model, input=texts)
        return [item.embedding for item in resp.data]


llm = LLMClient()
