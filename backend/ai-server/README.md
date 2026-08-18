# WisTable 独立 AI 服务

可插拔的独立 AI 服务，通过 WisTable 的 Fusion API 读写表格，与主系统最大解耦。
本服务**不启动不影响** WisTable 任何现有功能，前端会自动降级提示。

## 功能

1. **数据智能解析导入**：上传 PDF/Word/发票图片，经 MinerU 解析 + LLM 字段抽取，自动导入表格。
2. **智能问数**：自然语言对表格数据提问，支持 5000+ 行大表（向量检索 + 本地精确聚合双通道）。

## 目录结构

```
app.py               FastAPI 入口（/health、/import/*、/ask）
config.py            配置（WisTable / LLM / MinerU / 向量库）
wis_table_client.py  Fusion API 封装（读字段/记录、写记录/命令、附件）
mineru_client.py     MinerU 封装（自部署 / 云端双模式）
llm.py               LLM 接入（OpenAI 兼容 + Embedding）
extract.py           功能①：字段 schema 驱动的信息抽取 + 字段类型对齐
```

## 配置

```bash
cp .env.example .env   # 按需填写
```

关键项：
- `WISTABLE_FUSION_BASE_URL`：room-server 的 `/fusion/v1` 地址（开发 `http://127.0.0.1:3333/fusion/v1`）
- `WISTABLE_API_TOKEN`：用户在 WisTable「开发者配置」里生成的 `usk...` API key
- `LLM_*` / `EMBEDDING_*`：OpenAI 兼容端点（可指向 DeepSeek/通义/Moonshot 等）
- `MINERU_MODE` + `MINERU_*`：`selfhosted`（自部署 mineru-api）或 `cloud`（mineru.net）

## 启动

```bash
pip install -r requirements.txt
uvicorn app:app --host 0.0.0.0 --port 8001
# 或
docker build -t wistable/ai-service . && docker run -p 8001:8001 --env-file .env wistable/ai-service
```

验证：`curl http://127.0.0.1:8001/health`

## API

统一返回 `{ "success": bool, "data"?: ..., "message"?: str }`；`success=false` 时 `message` 为可直接展示给用户的错误信息。

### GET /health

可用性探测。返回 `status` + 各依赖就绪状态（`wistable_ready` / `llm_ready` / `embedding_ready` / `mineru_ready` / `mineru_mode`）。

### POST /import/parse（multipart）

上传文档并抽取预览，**不写库**。

- 表单字段：`file`（PDF/Word/图片）、`dst_id`（目标表 ID）
- 返回 `data`：
  - `filename` 文件名
  - `markdown` MinerU 解析文本（截断 4000 字，仅供预览）、`markdown_length` 全文长度
  - `fields` 目标表字段 schema（供前端做字段映射/预览）
  - `records` 抽取并按字段类型对齐后的记录 `[{字段名:值}]`、`record_count`

字段类型对齐规则：Number/Currency→数值、Percent→小数(0~1)、Checkbox→布尔、SingleSelect→匹配已有选项名、MultiSelect→选项名数组、其余（含 DateTime）→字符串。

### POST /import/commit（JSON）

把用户确认后的记录写回目标表。

- Body：`{ "dst_id": str, "records": [{字段名:值}] }`
- 返回 `data`：`created`（新记录）、`count`
- records 接口单次上限 10 条，超限自动分片写回

### POST /ask（阶段 2 待实现）

## 前端接入（可插拔）

- 前端 `get_env.ts` 暴露 `AI_SERVICE_VISIBLE` 开关
- dev：`frontend/datasheet/server.js` 将 `/ai/*` 反代到本服务
- prod：`gateway/` nginx 加 `/ai` location
- 前端入口挂载时探测 `/ai/health`，失败则降级为「服务暂不可用」提示

## 开发阶段

- [x] 阶段 0：地基（本骨架 + `/health` + WisTable 客户端）
- [x] 阶段 1 后端：文档解析导入（`/import/parse`、`/import/commit`、`extract.py`）
- [ ] 阶段 1 前端：上传入口 + 字段映射预览 + 确认写回
- [ ] 阶段 2：智能问数（`/ask`、数据同步 + 向量索引）
