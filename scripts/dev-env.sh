#!/usr/bin/env bash
# ---------------------------------------------------------
# WisTable 开发环境激活脚本
# 激活 Node16 + JDK17 + 加载 .env + 重写 host 为 127.0.0.1
# 仅对当前 shell 生效,不动系统默认
#
# 用法:  source scripts/dev-env.sh
# ---------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

# ---- Node 16 ----
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
nvm use >/dev/null 2>&1 || nvm use 16.15.0 >/dev/null 2>&1

# ---- JDK 17 ----
JAVA_HOME="$(ls -d "$HOME"/.jdks/amazon-corretto-17* 2>/dev/null | head -1)"
export JAVA_HOME
export PATH="$JAVA_HOME/bin:$PATH"

# ---- Load .env (docker-compose uses this for production) ----
if [ -f "$REPO_ROOT/.env" ]; then
  set -a
  # shellcheck disable=SC1091
  source "$REPO_ROOT/.env"
  set +a
fi

# ---- Override hosts for native dev (connect to Docker-exposed ports) ----
export TZ="${TIMEZONE:-Asia/Shanghai}"
export DEFAULT_TIME_ZONE="${TIMEZONE:-Asia/Shanghai}"
export AWS_ENDPOINT=http://127.0.0.1:9000
export MYSQL_HOST=127.0.0.1
export RABBITMQ_HOST=127.0.0.1
export REDIS_HOST=127.0.0.1

export BACKEND_BASE_URL=http://127.0.0.1:8081/api/v1/
export BACKEND_INFO_URL=http://127.0.0.1:8081/api/v1/client/info
export DATABUS_SERVER_BASE_URL=http://127.0.0.1:8625
export NEST_GRPC_ADDRESS=static://127.0.0.1:3334
export ROOM_GRPC_URL=127.0.0.1:3334
export SOCKET_DOMAIN=http://127.0.0.1:3333/socket
export SOCKET_GRPC_URL=127.0.0.1:3007
export SOCKET_URL=http://127.0.0.1:3002

export ASSETS_URL=http://127.0.0.1:9000/assets/
export OSS_HOST=http://127.0.0.1:9000/assets
export QNY1=http://127.0.0.1:9000/assets/
export QNY2=http://127.0.0.1:9000/assets/
export QNY3=http://127.0.0.1:9000/assets/

export API_PROXY=
export API_DOCS_ENABLED=true
export ENABLE_SWAGGER=true

echo "dev toolchain: node $(node -v 2>/dev/null) | $(java -version 2>&1 | head -1)"
echo "hosts → 127.0.0.1  (mysql/redis/rabbitmq/minio)"
