#
# Logs into Github using SSH
# Assumes you have setup an SSH Key w/ Github
# For Setup details see:
# https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh
#
github_login(){
    local cur_dir = ${PWD}
    if [[ -z ${GITHUB_SSH_KEY_NAME} ]]; then
      eval $(ssh-agent -s)
      cd ~/.ssh/
      ssh-add ${GITHUB_SSH_KEY_NAME}
      cd ${cur_dir}
    else
      echo "Must specify the name for your Github Key in '${GITHUB_SSH_KEY_NAME}'"
      exit 1
    fi

    ssh -T git@github.com
    if [[ $? -ne 0 ]]; then
      echo "Could not log in to Github. Verify ${GITHUB_SSH_KEY_NAME} is in Githubs SSH Settings"
      exit 1
    fi
}

#
# Upgrade git cli version
# Usefull when package managers (e.g. yum) don't
# support the latest version of git
#
