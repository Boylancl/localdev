#! /usr/bin/zsh

WORKING_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

# Activate the SSH agent in this shell
eval $(ssh-agent -s)

# Add Localdev Functions
source ${WORKING_DIR}/functions.sh

# Set Defaults for Github
git config --global user.email "boylancl@gmail.com"
git config --global user.name "Clay Boylan"
GITHUB_SSH_KEY_NAME=~/.ssh/github_ed25519
github_login

# Powerline Config
POWERLEVEL9K_VCS_BRANCH_ICON=$'\uF126 '
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(aws background_jobs time)

export PATH="/home/boylancl/.local/bin:$PATH"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

eval "$(pyenv init -)"
