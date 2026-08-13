# 开发部署指导


## 生产部署

```bash
# 1. 克隆仓库（databus-server 镜像归档已在仓库中）
git clone <repo-url> wistable
cd wistable

# 2. 加载 databus-server 镜像
docker load -i docker/databus-server.tar

# 3. 配置环境变量
cp .env.example .env            # 替换 CHANGE_ME 占位符为真实密码/密钥
# 必须填写的变量：
#   MYSQL_PASSWORD, MYSQL_ROOT_PASSWORD, REDIS_PASSWORD, RABBITMQ_PASSWORD
#   MINIO_ACCESS_KEY, MINIO_SECRET_KEY, AWS_ACCESS_KEY, AWS_ACCESS_SECRET
#   SOCKET_AUTH_TOKEN (任意随机字符串)

# 4. 启动全部服务（首次会构建镜像，约 10-20 分钟）
docker compose --env-file .env up -d

# 5. 编译部署小组件（仅首次需要，JS 包不在 Docker 镜像中）
# 前置条件：Node 16 + 全局安装 @apitable/widget-cli + pip install boto3
source scripts/dev-env.sh
bash frontend/widgets/build-and-deploy.sh

# 6. 访问 http://localhost:8080
# 默认账号: admin@qq.com / admin123
```

| 命令 | 说明 |
|------|------|
| `docker compose --env-file .env up -d` | 启动全部服务（生产模式） |
| `docker compose --env-file .env up -d --build` | 重建镜像并启动 |
| `docker compose build [service]` | 构建单个服务镜像 |
| `docker compose down --remove-orphans` | 停止并清理 |
| `docker compose ps` | 查看服务状态 |
| `docker compose logs -f [service]` | 查看服务日志 |


## 开发环境

开发模式: 基础设施跑 Docker，业务代码本地原生运行，支持热更新。

### 首次部署

```bash
# 一键部署开发工具链 + 安装项目依赖 + 创建数据目录
bash scripts/setup-dev.sh
```

### 日常使用

```bash
# 1. 加载 databus-server 镜像（首次需要）
docker load -i docker/databus-server.tar

# 2. 激活开发环境 (Node16 + JDK17 + 加载 .env + host 指向 127.0.0.1)
source scripts/dev-env.sh

# 3. 启动基础设施 (mysql/redis/rabbitmq/minio/init-db/databus)
docker compose -f docker-compose.dev.yaml --env-file .env up -d

# 4. 编译部署小组件到 MinIO（首次必须执行）
bash frontend/widgets/build-and-deploy.sh

# 5. 分别启动三个业务服务（可在 IDE 或不同终端中启动）
cd backend/backend-server && ./gradlew bootRun      # Java 后端 (8081)
cd backend/room-server && pnpm start:dev            # NestJS 协作服务 (3333)
cd frontend/datasheet && pnpm dev                   # Next.js 前端 (3000)

# 停止基础设施
docker compose -f docker-compose.dev.yaml down --remove-orphans
```

> `source scripts/dev-env.sh` 会将 `MYSQL_HOST`、`REDIS_HOST`、`RABBITMQ_HOST`、`AWS_ENDPOINT` 等重写为 `127.0.0.1`，让本地进程能连接到 Docker 暴露的端口。


## 修改源码后更新部署

### 开发模式

开发模式下代码本地运行，改完即生效（热更新），无需任何额外操作。只有改了小组件源码时需要重新编译部署：

```bash
source scripts/dev-env.sh
bash frontend/widgets/build-and-deploy.sh
# 重启 backend-server 生效
```

### 生产模式

生产模式下代码跑在 Docker 镜像中，修改源码后需要重建对应镜像并重启：

| 改了这里 | 重建命令 | 说明 |
|----------|---------|------|
| `frontend/datasheet/`、`packages/core/`、`frontend/widget-sdk/` | `docker compose build web-server` | 前端和共享库 |
| `backend/room-server/` | `docker compose build room-server` | NestJS 协作服务 |
| `backend/backend-server/` | `docker compose build backend-server` | Java 后端 |
| `gateway/conf.d/` | `docker compose build gateway` | Nginx 配置 |
| `init-db/` | `docker compose build init-db` | 数据库种子数据 |

```bash
# 改了源码后，典型更新流程：
docker compose build <service>    # 重建镜像
docker compose --env-file .env up -d   # 用新镜像重启
```

以下情况**不需要**重建镜像：

- 只改了 `.env`（`docker compose up -d` 会重新注入）
- 只改了 `docker-compose.yaml`（编排文件，不是镜像）
- 日常开发模式（代码在本地跑，不碰镜像）

## 项目结构

```text
wistable/
  # ── 部署 ──
  docker-compose.yaml          # 生产环境 Docker 编排
  docker-compose.dev.yaml      # 开发环境基础设施编排（端口暴露到宿主机）
  .env                         # 环境变量（不入 git，基于 .env.example 创建）
  .env.example                 # 环境变量模板

  # ── Docker 构建 ──
  docker/
    Dockerfile.backend-server  # Java 后端镜像
    Dockerfile.room-server     # NestJS 协作服务镜像
    Dockerfile.web-server      # Next.js 前端镜像
    Dockerfile.gateway         # Nginx 网关镜像
    Dockerfile.databus-server  # Databus-server 镜像包装
    databus-server.tar         # Databus-server 镜像归档（56MB，在 git 中）
  init-db/                     # 数据库初始化镜像
    Dockerfile
    01_schema.sql              # 建表语句
    02_user.sql                # 默认管理员账号
    03_template.sql            # 模板数据
    04_widget.sql              # 小组件包注册数据
    05_automation.sql          # 自动化触发器和动作类型
  gateway/                     # Nginx 反向代理配置
    conf.d/

  # ── JS/TS monorepo（pnpm + Nx） ──
  package.json                 # 根包（scripts + devDependencies）
  pnpm-workspace.yaml          # pnpm 工作区
  nx.json                      # Nx 构建编排
  tsconfig.json                # TypeScript 根配置
  .eslintrc                    # ESLint 配置
  .prettierrc                  # Prettier 配置（单引号/分号/printWidth:150）
  .nvmrc                       # Node 版本（16.15.0）
  patches/
    mysql2@3.9.7.patch         # mysql2 utf8mb3 兼容补丁

  # ── 共享包 ──
  packages/
    core/                      # @apitable/core — 核心引擎（Redux/OT/公式/命令）
    i18n-lang/                 # @apitable/i18n-lang — 国际化字符串

  # ── 前端 ──
  frontend/
    datasheet/                 # @apitable/datasheet — Next.js 主应用
    components/                # @apitable/components — UI 组件库
    icons/                     # @apitable/icons — 图标库
    widget-sdk/                # @apitable/widget-sdk — 小组件运行时 SDK
    widgets/                   # 小组件源码（10 个）
      README.md                # 小组件开发详细文档
      build-and-deploy.sh      # 一键编译部署脚本
      widget-dev-guide.md      # 小组件开发 API 参考

  # ── 后端 ──
  backend/
    backend-server/            # Java Spring Boot（Gradle 多模块）
    room-server/               # @apitable/room-server（NestJS）
      src/automation/          # 自动化引擎
        README.md              # 自动化模块文档

  # ── 脚本 / 文档 ──
  scripts/
    setup-dev.sh               # 新机器一键部署开发环境
    dev-env.sh                 # 激活开发环境（Node16 + JDK17 + host 重写）
    export-env.sh              # 导出 .env 为环境变量
    compile.proto.sh           # gRPC proto 代码生成
    protos/                    # gRPC 接口定义（.proto）
  DEVELOPMENT.md               # 本文档
  CLAUDE.md                    # AI 协作参考（架构/模式/约定）
  README.md                    # 项目简介
```


## 常见问题

### 部署相关

**Q: 启动后访问 8080 端口无响应？**

先用 `docker compose ps` 检查各服务状态，再用 `docker compose logs -f` 查看日志。常见原因：

- `.env` 中 `CHANGE_ME` 占位符未替换
- `SOCKET_AUTH_TOKEN` 未设置
- `databus-server.tar` 未加载

**Q: 生产模式下前端页面空白？**

检查是否执行了小组件部署步骤（`bash frontend/widgets/build-and-deploy.sh`），JS 包不在 Docker 镜像中。

**Q: 如何完全重置数据重新部署？**

```bash
docker compose down -v --remove-orphans   # 删除容器和数据卷
docker compose --env-file .env up -d       # 重新启动（init-db 会重新初始化）
bash frontend/widgets/build-and-deploy.sh  # 重新部署小组件
```

### 开发相关

**Q: 本地服务启动报数据库/Redis 连接失败？**

确认已经执行 `source scripts/dev-env.sh`，它会将 host 重写为 `127.0.0.1`。执行后可用 `echo $MYSQL_HOST` 验证。

**Q: 小组件脚本报 MinIO 连接失败？**

同样需要先 `source scripts/dev-env.sh` 加载环境变量。另外确认 `pip install boto3` 已安装。

**Q: `pnpm` 命令报 `command not found`？**

Node 版本不对，需要 Node 16 + pnpm 8。用 `source scripts/dev-env.sh` 激活或手动 `nvm use 16`。

### 自动化相关

**Q: 自动化配置好了但无法启用（提示"触发条件和动作配置不完整"）？**

通常是表单中下拉框等有默认值的字段没有主动操作过，默认值未写入保存数据。解决方法：重新点选一次下拉框字段再保存。详见 `backend/room-server/src/automation/README.md`。

### 小组件相关

**Q: 小组件面板看不到或加载失败？**

- 确认已执行 `bash frontend/widgets/build-and-deploy.sh`
- 确认已重启 backend-server
- 检查 MinIO 中对应路径的文件是否存在

详见 `frontend/widgets/README.md`。
