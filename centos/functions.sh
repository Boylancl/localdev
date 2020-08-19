#
# Logs into Github using SSH
# Assumes you have setup an SSH Key w/ Github
# For Setup details see:
# https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh
#
github_login(){
  if [[ -z ${GITHUB_SSH_KEY_NAME} ]]; then
    echo 'Must specify the name for your Github Key in ${GITHUB_SSH_KEY_NAME}'
    echo 'Try: export GITHUB_SSH_KEY_NAME=~/.ssh/github_rsa'
    return 1
  else
    eval $(ssh-agent -s)
    ssh-add ${GITHUB_SSH_KEY_NAME}
  fi

  ssh -T git@github.com
}

#
# Upgrade git cli version
# Usefull when package managers (e.g. yum) don't
# support the latest version of git
#
update_git_cli(){
  if [[ -z $1 ]]; then
    echo "No version specified will pull yum latest"
    yum install git
    git --version
    return
  fi

  echo "Attempting to pull and compile git version $1"
  sudo yum groupinstall "Development Tools" -y
  sudo yum install gettext-devel openssl-devel perl-CPAN perl-devel zlib-devel curl-devel -y
  wget https://github.com/git/git/archive/v$1.tar.gz -O .tmp/git.tar.gz && \
  tar -zxf .temp/git.tar.gz && \
  cd .temp/git-* && \
  make configure && \
  ./configure --prefix=/usr/local && \
  sudo make install
  git --version
}