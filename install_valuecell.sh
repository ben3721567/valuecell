#!/bin/bash
set -e

echo "🚀 开始安装 ValueCell..."
echo "==================================="

# === 1. 检查并安装依赖工具 ===
install_uv() {
    if ! command -v uv &>/dev/null; then
        echo "📦 安装 uv..."
        curl -fsSL https://astral.sh/uv/install.sh | sh
    else
        echo "✅ uv 已安装"
    fi
}

install_bun() {
    if ! command -v bun &>/dev/null; then
        echo "📦 安装 bun..."
        curl -fsSL https://bun.sh/install | bash
        export PATH="$HOME/.bun/bin:$PATH"
    else
        echo "✅ bun 已安装"
    fi
}

install_uv
install_bun

# === 2. 克隆仓库 ===
if [ ! -d "ValueCell" ]; then
    echo "📥 克隆 ValueCell 仓库..."
    git clone https://github.com/你的仓库地址/ValueCell.git
else
    echo "📂 已存在 ValueCell 文件夹，跳过克隆"
fi
cd ValueCell

# === 3. 交互式生成 .env 文件 ===
echo "🛠 配置环境变量 (.env)"
echo "--------------------------------"

read -p "APP 环境 (development/production) [development]: " APP_ENVIRONMENT
APP_ENVIRONMENT=${APP_ENVIRONMENT:-development}

read -p "启用 API? (true/false) [true]: " API_ENABLED
API_ENABLED=${API_ENABLED:-true}

read -p "API Host [localhost]: " API_HOST
API_HOST=${API_HOST:-localhost}

read -p "API Port [8000]: " API_PORT
API_PORT=${API_PORT:-8000}

read -p "语言 (zh-Hans/en) [zh-Hans]: " LANG
LANG=${LANG:-zh-Hans}

read -p "时区 [America/New_York]: " TIMEZONE
TIMEZONE=${TIMEZONE:-America/New_York}

# 模型 API Keys
echo "=== 模型提供商 API Keys ==="
read -p "OpenRouter API Key: " OPENROUTER_API_KEY
read -p "Azure OpenAI API Key (可选): " AZURE_OPENAI_API_KEY
read -p "Google API Key (可选): " GOOGLE_API_KEY
read -p "SiliconFlow API Key (可选): " SILICONFLOW_API_KEY
read -p "OpenAI API Key (可选): " OPENAI_API_KEY

# 第三方 Keys
echo "=== 第三方 API Keys ==="
read -p "SEC Email (可选): " SEC_EMAIL
read -p "Finnhub API Key: " FINNHUB_API_KEY
read -p "Xueqiu Token (可选): " XUEQIU_TOKEN

cat > .env <<EOF
# ============================================
# Application Settings
# ============================================
APP_NAME=ValueCell
APP_VERSION=0.1.0
APP_ENVIRONMENT=$APP_ENVIRONMENT
API_DEBUG=true

# ============================================
# API Settings
# ============================================
API_ENABLED=$API_ENABLED
API_I18N_ENABLED=true
API_HOST=$API_HOST
API_PORT=$API_PORT
LANG=$LANG
TIMEZONE=$TIMEZONE
PYTHONIOENCODING=utf-8

# ============================================
# Agent Settings
# ============================================
AGENT_DEBUG_MODE=false

# ============================================
# Model Provider Settings
# ============================================
OPENROUTER_API_KEY=$OPENROUTER_API_KEY
AZURE_OPENAI_API_KEY=$AZURE_OPENAI_API_KEY
GOOGLE_API_KEY=$GOOGLE_API_KEY
SILICONFLOW_API_KEY=$SILICONFLOW_API_KEY
OPENAI_API_KEY=$OPENAI_API_KEY

# ============================================
# Research Agent Configurations
# ============================================
SEC_EMAIL=$SEC_EMAIL

# ============================================
# Third-Party Agent Configurations
# ============================================
FINNHUB_API_KEY=$FINNHUB_API_KEY

# ============================================
# Additional Configurations
# ============================================
XUEQIU_TOKEN=$XUEQIU_TOKEN
EOF

echo "✅ .env 文件已生成"

# === 4. 安装依赖 ===
echo "📦 安装 Python 依赖..."
uv sync

echo "📦 安装前端依赖..."
bun install

# === 5. 启动应用堆栈 ===
echo "🚀 启动 ValueCell..."
bun dev &

echo "🌐 访问地址: http://localhost:1420"
echo "✅ 安装完成！"
