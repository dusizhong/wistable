"""AI 服务配置：全部从环境变量 / .env 文件读取。

独立的 AI 服务不侵入 WisTable，只通过 Fusion API 与之交互。
"""
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file='.env', env_file_encoding='utf-8', extra='ignore')

    # ---- WisTable（Fusion API）----
    wistable_fusion_base_url: str = 'http://127.0.0.1:3333/fusion/v1'
    wistable_api_token: str = ''

    # ---- LLM（OpenAI 兼容协议）----
    llm_base_url: str = 'https://api.openai.com/v1'
    llm_api_key: str = ''
    llm_model: str = 'gpt-4o'

    # ---- Embedding（智能问数用）----
    embedding_base_url: str = 'https://api.openai.com/v1'
    embedding_api_key: str = ''
    embedding_model: str = 'text-embedding-3-small'

    # ---- MinerU（文档解析）----
    mineru_mode: str = 'selfhosted'  # selfhosted | cloud
    mineru_self_host_url: str = 'http://127.0.0.1:8000'
    mineru_cloud_base_url: str = 'https://mineru.net/api/v4'
    mineru_cloud_token: str = ''

    # ---- 向量库（智能问数）----
    chroma_persist_dir: str = './.chroma'

    # ---- 服务 ----
    ai_service_host: str = '0.0.0.0'
    ai_service_port: int = 8001

    @property
    def wistable_ready(self) -> bool:
        return bool(self.wistable_api_token)

    @property
    def llm_ready(self) -> bool:
        return bool(self.llm_api_key)

    @property
    def embedding_ready(self) -> bool:
        return bool(self.embedding_api_key)

    @property
    def mineru_ready(self) -> bool:
        if self.mineru_mode == 'cloud':
            return bool(self.mineru_cloud_token)
        return True


settings = Settings()
