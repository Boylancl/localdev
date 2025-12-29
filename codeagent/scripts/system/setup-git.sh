#!/usr/bin/env bash
set -euo pipefail

echo "==> Installing git (if missing)"
if ! command -v git >/dev/null; then
  sudo apt update -y
  sudo apt install -y git
fi

echo "==> Installing github cli (if missing)"
if ! command -v gh >/dev/null; then
  sudo apt update -y
  sudo apt install -y gh
fi

echo "==> Installing SSH tooling"
sudo apt update -y
sudo apt install -y openssh-client xclip

echo "==> Git version"
git --version

# --- User identity ---
read -rp "Git user.name: " GIT_NAME
read -rp "Git user.email (also used for SSH key label): " GIT_EMAIL

git config --global user.name  "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"

# --- Core behavior ---
git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global fetch.prune true
git config --global core.autocrlf input
git config --global core.editor "nano"

# --- Diff / merge quality-of-life ---
git config --global diff.algorithm histogram
git config --global merge.conflictStyle zdiff3
git config --global rerere.enabled true

# --- Safety & performance ---
git config --global gc.auto 256
git config --global commit.gpgsign false

# --- Credential helper (WSL-friendly) ---
if grep -qi microsoft /proc/version; then
  echo "==> Detected WSL, using Windows credential manager (if available)"
  if [[ -x "/mnt/c/Program Files/Git/mingw64/bin/git-credential-manager.exe" ]]; then
    git config --global credential.helper "/mnt/c/Program\\ Files/Git/mingw64/bin/git-credential-manager.exe"
  else
    echo "    - Windows Git Credential Manager not found; leaving credential.helper unchanged."
  fi
else
  git config --global credential.helper store
fi

# --- SSH key generation ---
echo ""
echo "==> SSH key setup"
mkdir -p ~/.ssh
chmod 700 ~/.ssh

KEY_PATH="${HOME}/.ssh/id_ed25519"
if [[ -f "${KEY_PATH}" ]]; then
  echo "    - SSH key already exists at ${KEY_PATH} (skipping generation)"
else
  echo "    - Generating a new ed25519 SSH key"
  ssh-keygen -t ed25519 -C "${GIT_EMAIL}" -f "${KEY_PATH}"
fi

# Start ssh-agent and add key (best effort)
echo "==> Starting ssh-agent and adding key"
eval "$(ssh-agent -s)" >/dev/null
ssh-add "${KEY_PATH}" >/dev/null 2>&1 || true

echo "==> Testing GitHub SSH connection..."
echo ""

set +e
ssh -T git@github.com 2>&1 | tee /tmp/github_ssh_test.log
SSH_EXIT_CODE=${PIPESTATUS[0]}
set -e

if grep -q "successfully authenticated" /tmp/github_ssh_test.log; then
  echo ""
  echo "✅ GitHub SSH authentication successful."
  echo "==> Git configuration complete"
  exit 0
fi

echo ""
echo "❌ GitHub SSH authentication failed."
echo ""
echo "Common fixes:"
echo "  - Add your SSH public key to GitHub"
echo "  - Ensure ssh-agent is running and your key is added"
echo "  - Check ~/.ssh/id_ed25519 exists"
echo ""
echo "Your public key (copy this into GitHub):"
echo "--------------------------------------------------"
cat ~/.ssh/id_ed25519.pub 2>/dev/null || echo "No SSH key found at ~/.ssh/id_ed25519.pub"
echo "--------------------------------------------------"
echo ""

read -rp "Fix the issue, then press ENTER to retry (Ctrl+C to abort)..."

ssh -T git@github.com
set +e
ssh -T git@github.com 2>&1 | tee /tmp/github_ssh_test.log
SSH_EXIT_CODE=${PIPESTATUS[0]}
set -e

if grep -q "successfully authenticated" /tmp/github_ssh_test.log; then
  echo ""
  echo "✅ GitHub SSH authentication successful."
  echo "==> Git configuration complete"
  exit 0
fi

echo ""
echo "❌ GitHub SSH authentication failed."
echo ""
echo "Common fixes:"
echo "  - Add your SSH public key to GitHub"
echo "  - Ensure ssh-agent is running and your key is added"
echo "  - Check ~/.ssh/id_ed25519 exists"
echo ""
echo "Your public key (copy this into GitHub):"
echo "--------------------------------------------------"
cat ~/.ssh/id_ed25519.pub 2>/dev/null || echo "No SSH key found at ~/.ssh/id_ed25519.pub"
echo "--------------------------------------------------"
echo ""

exit 1

