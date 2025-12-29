#!/usr/bin/env bash
set -euo pipefail

WORKING_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

echo "===> Setup Git"
chmod +x ${WORKING_DIR}/setup-git.sh
${WORKING_DIR}/setup-git.sh

echo "===> Setup zShell"
chmod +x ${WORKING_DIR}/install-zshell.sh
${WORKING_DIR}/install-zshell.sh

echo "===> Install Brew"
chmod +x ${WORKING_DIR}/install-brew.sh
${WORKING_DIR}/install-brew.sh


echo "===> Install OpenAI Codex"
chmod +x ${WORKING_DIR}/install-codex-deps.sh
sudo ${WORKING_DIR}/install-codex-deps.sh

echo "===> Install Gemini"
chmod +x ${WORKING_DIR}/install-gemini-cli.sh
${WORKING_DIR}/install-gemini-cli.sh

echo "===> Install Claude Code"
curl -fsSL https://claude.ai/install.sh | bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc


source ~/.zshrc


