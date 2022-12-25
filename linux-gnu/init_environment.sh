#1 /usr/bin/bash

WORKING_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

apt-get install -y zsh && \
apt update -y && apt upgrade -y && \
apt install -y wget && \
apt-get install -y gcc && \
apt-get install -y make build-essential libssl-dev zlib1g-dev && \
apt-get install -y pip
