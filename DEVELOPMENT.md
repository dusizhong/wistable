# 开发部署指导

本文为开发部署技术指导文档。


## 生产部署

```bash
# 1. 配置 Docker 镜像加速
sudo tee /etc/docker/daemon.json >/dev/null <<'EOF'
{ "registry-mirrors": ["https://docker.m.daocloud.io"] }
EOF
sudo systemctl restart docker

# 2. 克隆代码
git clone <repo-url> wistable
cd wistable

# 3. 加载专有镜像包（专有镜像包构建详见常见问题3）
scp docker/databus-server.tar docker/apitable-node.tar docker/apitable-nodepy.tar docker/widget-deploy.tar user@服务器:~/wistable/docker/
docker load -i docker/databus-server.tar
docker load -i docker/apitable-node.tar
docker load -i docker/apitable-nodepy.tar
docker load -i docker/widget-deploy.tar

# 4. 配置环境变量
# IMAGE_PULL_POLICY设置为if_not_present
# 替换 CHANGE_ME 为真实密码（MYSQL/REDIS/MINIO/RABBITMQ_PASSWORD/SOCKET_AUTH_TOKEN）
cp .env.example .env 

# 5. 启动全部服务
docker compose --env-file .env up -d

# 6. 编译部署小组件
# 用第 3 步已加载的 widget-deploy 镜像（一次性容器），服务器无需 Node/Python 工具链
docker compose --env-file .env --profile widgets run --rm widget-init
docker compose --env-file .env restart backend-server

# 7. 访问（默认账号: admin@qq.com / admin123）
http://localhost:8080
```


## 开发部署

开发模式: 基础设施跑 Docker，业务代码本地原生运行，支持热更新。

### 首次部署

```bash
# 一键部署开发工具链 + 安装项目依赖 + 创建数据目录
bash scripts/setup-dev.sh
# 加载 databus-server 镜像（首次需要；databus-server 为 apitable 专有镜像，Docker Hub 拉不到，故本地加载）
docker load -i docker/databus-server.tar
```

### 日常使用

```bash
# 2. 激活开发环境 (Node16 + JDK17 + 加载 .env + host 指向 127.0.0.1)
source scripts/dev-env.sh

# 3. 启动基础设施 (mysql/redis/rabbitmq/minio/init-db/databus)
docker compose -f docker-compose.dev.yaml --env-file .env up -d

# 4. 编译部署小组件到 MinIO（首次执行）
bash frontend/widgets/build-and-deploy.sh

# 5. 分别启动三个业务服务（可在 IDE 或不同终端中启动）
cd backend/backend-server && ./gradlew bootRun      # Java 后端 (8081)
cd backend/room-server && pnpm start:dev            # NestJS 协作服务 (3333)
cd frontend/datasheet && pnpm dev                   # Next.js 前端 (3000)

# 停止基础设施
docker compose -f docker-compose.dev.yaml down --remove-orphans
```


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
    Dockerfile.widget-deploy   # 小组件编译部署工具链镜像（在能联网机器上构建）
    databus-server.tar         # Databus-server 镜像归档（56MB，不入 git，scp 上传）
    apitable-node.tar          # apitable/node 基础镜像归档（>100MB，不入 git，scp 上传）
    apitable-nodepy.tar        # apitable/nodepy 基础镜像归档（>100MB，不入 git，scp 上传）
    widget-deploy.tar          # 小组件工具链镜像归档（>100MB，不入 git，scp 上传）
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

***1. 修改代码后，生产环境中如何更新部署？***

```bash
git pull
docker compose build <service>    # 重建镜像
docker compose --env-file .env up -d   # 用新镜像重启
```

***2. 如何查看docker日志？***
```bash
docker ps
docker logs -f wistable-backend-server-1    # 示例
```

***3. 如何在本地构建apitable专有镜像包？***
```
# 在能联网的机器上执行（这些apitable专有镜像，Docker可能拉取不到，故采用本地构建后上传镜像包到服务器上加载）
docker pull apitable/node:v16.15.0
docker pull apitable/nodepy:16.15.0-alpine
docker save -o docker/apitable-node.tar   apitable/node:v16.15.0
docker save -o docker/apitable-nodepy.tar apitable/nodepy:16.15.0-alpine

# 小组件工具链镜像（node + widget-cli + boto3 + mysql，阿里云源加速构建）
docker build -f docker/Dockerfile.widget-deploy -t wistable/widget-deploy:latest .
docker save -o docker/widget-deploy.tar   wistable/widget-deploy:latest

# 注：databus-server.tar 为预编译 Rust 二进制（源码不在本仓库），无法本地构建，需从已有环境拷贝
```

***4. 如何完全重置数据重新部署？***

```bash
docker compose down -v --remove-orphans   # 删除容器和数据卷
docker compose --env-file .env up -d       # 重新启动（init-db 会重新初始化）
docker compose --env-file .env --profile widgets run --rm widget-init  # 重新部署小组件
```
