#!/usr/bin/env bash
# =============================================================
# WisTable 开发环境一键部署脚本
# 新电脑上 clone 项目后,跑一次此脚本即可就绪
# =============================================================
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

step()  { echo -e "\n${CYAN}[$1/$2]${NC} $3"; }
ok()    { echo -e "  ${GREEN}ok${NC}"; }
err()   { echo -e "  ${RED}FAIL${NC}: $1"; exit 1; }
check() { command -v "$1" >/dev/null 2>&1 && echo -e "  ${GREEN}$1 已装${NC}" || echo -e "  ${RED}$1 缺失${NC}"; }

TOTAL=9
N=0

# ---- inotify 监控上限 (避免 watch 模式 ENOSPC) ----
N=$((N+1)); step "$N" "$TOTAL" "inotify max_user_watches / max_user_instances"

set_inotify() {
    local name=$1 target=$2
    local current
    current=$(cat /proc/sys/fs/inotify/$name)
    if [ "$current" -ge "$target" ]; then
        echo "  $name 已是 ${current},跳过"
    else
        echo "  $name 当前 ${current} → 提升到 ${target}"
        sudo sysctl fs.inotify.$name=$target
        current=$(cat /proc/sys/fs/inotify/$name)
        if [ "$current" -ne "$target" ]; then
            err "$name 修改失败 (当前 $current)"
        fi
        if ! grep -q "^fs.inotify.$name" /etc/sysctl.conf 2>/dev/null; then
            echo "fs.inotify.$name=$target" | sudo tee -a /etc/sysctl.conf >/dev/null
        fi
    fi
}

set_inotify max_user_watches 524288
set_inotify max_user_instances 1024
ok

# ---- Node 16 via nvm ----
N=$((N+1)); step "$N" "$TOTAL" "Node 16.15.0 (nvm)"

export NVM_DIR="$HOME/.nvm"
if [ ! -s "$NVM_DIR/nvm.sh" ]; then
    echo "  安装 nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    [ -s "$NVM_DIR/nvm.sh" ] || err "nvm 安装失败,请手动安装后重试"
    export NVM_DIR="$HOME/.nvm"
    . "$NVM_DIR/nvm.sh"
else
    . "$NVM_DIR/nvm.sh"
fi
nvm install 16.15.0
nvm use 16.15.0
ok

# ---- 数据目录 ----
N=$((N+1)); step "$N" "$TOTAL" "创建运行时数据目录 (.data)"
mkdir -p .data/{mysql,minio/data,minio/config,redis,rabbitmq}
ok

# ---- pnpm via corepack ----
N=$((N+1)); step "$N" "$TOTAL" "pnpm 8.6.12 (corepack)"

corepack enable
corepack prepare pnpm@8.6.12 --activate
pnpm --version | grep -q 8.6 || err "pnpm 版本不符"
ok

# ---- JDK 17 (Corretto) ----
N=$((N+1)); step "$N" "$TOTAL" "JDK 17 (Amazon Corretto)"

JDK_DIR="$HOME/.jdks"
CORRETTO="$(ls -d "$JDK_DIR"/amazon-corretto-17* 2>/dev/null | head -1)"
if [ -z "$CORRETTO" ]; then
    mkdir -p "$JDK_DIR"
    ARCH=$(uname -m)
    if [ "$ARCH" = "x86_64" ]; then ARCH="x64"; fi
    URL="https://corretto.aws/downloads/latest/amazon-corretto-17-${ARCH}-linux-jdk.tar.gz"
    echo "  下载 Corretto 17 (~190MB)..."
    curl -sL "$URL" -o "$JDK_DIR/corretto17.tar.gz" || err "下载失败"
    tar xzf "$JDK_DIR/corretto17.tar.gz" -C "$JDK_DIR"
    rm "$JDK_DIR/corretto17.tar.gz"
    CORRETTO="$(ls -d "$JDK_DIR"/amazon-corretto-17* 2>/dev/null | head -1)"
fi
export JAVA_HOME="$CORRETTO"
export PATH="$JAVA_HOME/bin:$PATH"
java -version 2>&1 | head -1
ok

# ---- Canvas 系统库 (解决 canvas 编译的一劳永逸) ----
N=$((N+1)); step "$N" "$TOTAL" "Canvas 系统图形库 (cairo/pango/pixman等)"

# 检测是否已装
if pkg-config --cflags cairo >/dev/null 2>&1 && \
   pkg-config --cflags pixman-1 >/dev/null 2>&1 && \
   pkg-config --cflags pango >/dev/null 2>&1; then
    echo "  系统库已就绪,跳过"
else
    echo "  需要安装系统库 (需要 sudo/管理员权限)"
    if command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update -qq
        sudo apt-get install -y -qq \
            build-essential pkg-config \
            libcairo2-dev libpango1.0-dev \
            libjpeg-turbo8-dev libgif-dev librsvg2-dev \
            || err "系统库安装失败,请手动安装后重试"
    elif command -v yum >/dev/null 2>&1; then
        sudo yum install -y \
            gcc-c++ pkgconfig cairo-devel pango-devel \
            libjpeg-turbo-devel giflib-devel librsvg2-devel
    elif command -v brew >/dev/null 2>&1; then
        brew install pkg-config cairo pango libjpeg giflib librsvg
    else
        echo "  无法自动安装,请手动安装以下包后重试:"
        echo "  Debian/Ubuntu: sudo apt-get install build-essential pkg-config libcairo2-dev libpango1.0-dev libjpeg-turbo8-dev libgif-dev librsvg2-dev"
        echo "  macOS: brew install pkg-config cairo pango libjpeg giflib librsvg"
    fi
fi
ok

# ---- 项目 JS 依赖 ----
N=$((N+1)); step "$N" "$TOTAL" "pnpm install (项目依赖)"

cd "$SCRIPT_DIR/.."  # 回到仓库根
pnpm install
ok

# ---- 编译 canvas 原生模块 (利用刚装的系统库) ----
N=$((N+1)); step "$N" "$TOTAL" "编译 canvas.node"

CANVAS_DIR="node_modules/.pnpm/canvas@2.9.1/node_modules/canvas"
if [ -f "$CANVAS_DIR/build/Release/canvas.node" ]; then
    echo "  canvas.node 已存在,跳过"
else
    cd "$CANVAS_DIR"
    npx node-gyp rebuild
    cd "$SCRIPT_DIR/.."
fi
ok

# ---- 编译共享包 + room-server ----
N=$((N+1)); step "$N" "$TOTAL" "编译共享包 + room-server"

pnpm run build:dst:pre
pnpm run build:sr
ok

echo -e "\n${GREEN}============================================================${NC}"
echo -e "${GREEN}  开发环境部署完成!${NC}"
echo -e "${GREEN}============================================================${NC}"
echo ""
echo "  下次启动开发模式:"
echo "    source scripts/dev-env.sh"
echo "    docker compose -f docker-compose.dev.yaml --env-file .env up -d"
echo "    然后从 IDE 或终端手动启动 backend/room/web"
echo ""
echo "  canvas 问题已解决:系统库已装,canvas.node 已编译"
echo "  以后 pnpm install 会自动编译 canvas (系统库在就行)"
