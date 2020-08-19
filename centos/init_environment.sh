WORKING_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

yum install zsh -y && \
yum install wget -y && \
yum install gcc zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel tk-devel libffi-devel && \
chsh -s /bin/zsh root && \
echo $SHELL && \
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh && \
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc && \
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k && \
git clone https://github.com/pyenv/pyenv.git ~/.pyenv && \
echo "source ${WORKING_DIR}/localdev.sh" >> ~/.zshrc && \
source ~/.zshrc
