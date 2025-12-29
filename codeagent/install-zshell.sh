#!/usr/bin/env bash
set -euo pipefail

if command -v zsh >/dev/null 2>&1; then
  echo "zsh is installed"
  exit 0
else
  echo "zsh is NOT installed"
fi

echo "==> Installing zsh"
sudo apt update -y
sudo apt install -y zsh

echo "==> Zsh version"
zsh --version

# Set zsh as default shell (only if not already)
if [[ "$SHELL" != "$(command -v zsh)" ]]; then
  echo "==> Setting zsh as default shell"
  chsh -s "$(command -v zsh)"
  echo "    - Default shell will change on next login"
else
  echo "==> Zsh is already the default shell"
fi

# Optional: install Oh My Zsh
read -rp "Install Oh My Zsh? (y/N): " INSTALL_OMZ
if [[ "${INSTALL_OMZ,,}" == "y" ]]; then
  echo "==> Installing Oh My Zsh"
  if ! command -v curl >/dev/null; then
    sudo apt install -y curl
  fi
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo ""
echo "==> Zsh installation complete"
echo ""
echo "Restart your terminal or run:"
echo "  exec zsh"


