#! /usr/bin/bash

WORKING_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
os_functions="./${WORKING_DIR}/${OSTYPE}/functions.sh"

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


# set OS specific functions or overwrites
if [[ -f ${os_functions} ]]; then
    source ./${os_functions}
fi
