#!/usr/bin/env bash
set -euo pipefail

echo "==> Updating system"
sudo apt update -y
sudo apt upgrade -y

echo "==> Installing core system dependencies"
sudo apt install -y \
  ca-certificates \
  curl \
  git \
  build-essential \
  unzip \
  pkg-config \
  ripgrep \
  fd-find \
  tmux \
  software-properties-common

# Make fd available as `fd` (Ubuntu names it fdisk-find)
if command -v fdfind >/dev/null && ! command -v fd >/dev/null; then
  sudo ln -s "$(command -v fdfind)" /usr/local/bin/fd
fi

echo "==> Installing Python 3.10+ and tooling"
sudo apt install -y \
  python3 \
  python3-pip \
  python3-venv

echo "==> Create venv for Codex"
python3 -m venv ~/.venvs/codex
source ~/.venvs/codex/bin/activate

python3 -m pip install --upgrade pip setuptools wheel

echo "==> Installing Node.js 18+ (via NodeSource)"
if ! command -v node >/dev/null || [[ "$(node -v | cut -d. -f1 | tr -d v)" -lt 18 ]]; then
  curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
  sudo apt install -y nodejs
fi

echo "==> Verifying versions"
node -v
npm -v
python3 --version

echo "==> Installing Codex CLI"
if ! command -v codex >/dev/null; then
  npm install -g @openai/codex
fi

echo "==> Codex installation complete"
echo ""
echo "Next steps:"
echo "1. Set your API key:"
echo "   export OPENAI_API_KEY=\"sk-...\""
echo ""
echo "2. Run Codex from a project directory:"
echo "   codex"

