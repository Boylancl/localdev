#!/usr/bin/bash

WORKING_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
os_setup="${WORKING_DIR}/${OSTYPE}/init_environment.sh"

# OS specific setup
if [ -f ${os_setup} ]; then
    chmod 755 ${os_setup}
    sudo ${os_setup}
fi

wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh && \
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc && \
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k && \
git clone https://github.com/pyenv/pyenv.git ~/.pyenv && \
pyenv install 3.11.1 && \
pyenv global 3.11.1 && \
echo "source ${WORKING_DIR}/localdev_start.sh" >> ~/.zshrc && \
source ~/.zshrc

