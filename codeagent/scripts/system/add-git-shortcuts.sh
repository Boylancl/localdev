#!/usr/bin/env bash
set -euo pipefail

read -rp "Enter the shell file to update (e.g., ~/.bashrc or ~/.zshrc): " TARGET_FILE

if [[ -z "${TARGET_FILE}" ]]; then
  echo "No file provided. Exiting."
  exit 1
fi

# Expand ~ manually for portability.
if [[ "${TARGET_FILE}" == ~* ]]; then
  TARGET_FILE="${HOME}${TARGET_FILE#~}"
fi

if [[ ! -f "${TARGET_FILE}" ]]; then
  echo "File not found: ${TARGET_FILE}"
  exit 1
fi

BLOCK_START="# >>> codeagent git shortcuts >>>"
BLOCK_END="# <<< codeagent git shortcuts <<<"

if rg -q "^${BLOCK_START}$" "${TARGET_FILE}"; then
  echo "Shortcuts already installed in ${TARGET_FILE}."
  exit 0
fi

cat <<'BLOCK' >> "${TARGET_FILE}"
# >>> codeagent git shortcuts >>>
# Git shortcuts
CODEAGENT_GIT_BRANCH=""

codeagent_git_branch_refresh() {
  CODEAGENT_GIT_BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || true)"
}

g()   { codeagent_git_branch_refresh; git "$@"; }
ga()  { codeagent_git_branch_refresh; git add "$@"; }
gb()  { codeagent_git_branch_refresh; git branch "$@"; }
gbd() {
  codeagent_git_branch_refresh
  if [[ $# -eq 0 && -n "${CODEAGENT_GIT_BRANCH}" ]]; then
    git branch -d "${CODEAGENT_GIT_BRANCH}"
  else
    git branch -d "$@"
  fi
}
gco() { git checkout "$@"; codeagent_git_branch_refresh; }
gcb() { git checkout -b "$@"; codeagent_git_branch_refresh; }
gcm() { codeagent_git_branch_refresh; git commit -m "$*"; }
gca() { codeagent_git_branch_refresh; git commit --amend "$@"; }
gd()  { codeagent_git_branch_refresh; git diff "$@"; }
gds() { codeagent_git_branch_refresh; git diff --staged "$@"; }
gl()  { codeagent_git_branch_refresh; git pull "$@"; }
gp()  { codeagent_git_branch_refresh; git push "$@"; }
gst() { codeagent_git_branch_refresh; git status -sb "$@"; }
glg() { codeagent_git_branch_refresh; git log --oneline --graph --decorate "$@"; }

codeagent_git_branch_refresh
# <<< codeagent git shortcuts <<<
BLOCK

echo "Added git shortcuts to ${TARGET_FILE}."
