#!/usr/bin/env bash
set -euo pipefail


if command -v brew >/dev/null 2>&1; then
  echo "Homebrew is installed"
  exit 0
else
  echo "Homebrew is NOT installed"
fi

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "===> Add Homebrew to your PATH"
echo >> /home/boylancl/.zshrc
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/boylancl/.zshrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

echo "===> Install Homebrew's dependencies if you have sudo access"
sudo apt-get install build-essential

brew install gcc
