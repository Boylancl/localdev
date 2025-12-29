#!/usr/bin/env bash
set -euo pipefail

WORKING_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
SCRIPTS_DIR="${WORKING_DIR}/scripts"

echo "===> Setup Git"
chmod +x ${SCRIPTS_DIR}/system/setup-git.sh
${SCRIPTS_DIR}/system/setup-git.sh

echo "===> Setup zShell"
chmod +x ${SCRIPTS_DIR}/system/install-zshell.sh
${SCRIPTS_DIR}/system/install-zshell.sh

echo "===> Install Brew"
chmod +x ${SCRIPTS_DIR}/system/install-brew.sh
${SCRIPTS_DIR}/system/install-brew.sh


echo "===> Install OpenAI Codex"
chmod +x ${SCRIPTS_DIR}/agents/install-codex-deps.sh
sudo ${SCRIPTS_DIR}/agents/install-codex-deps.sh

echo "===> Install Gemini"
chmod +x ${SCRIPTS_DIR}/agents/install-gemini-cli.sh
${SCRIPTS_DIR}/agents/install-gemini-cli.sh

echo "===> Install Claude Code"
curl -fsSL https://claude.ai/install.sh | bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc


source ~/.zshrc
