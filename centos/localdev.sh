# Add Localdev Functions
source .localdev_functions

# Powerline Config
POWERLEVEL9K_VCS_BRANCH_ICON=$'\uF126 '
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(aws background_jobs time)

# add Pulumi to the PATH
export PATH=$PATH:$HOME/.pulumi/bin
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# Start in the Home Directory
cd ~