#!/bin/sh
set -e

# if occur error, please run "set -x" on behalf of "set -e"
# set -x

command_exists() {
    command -v "$@" > /dev/null 2>&1
}

docker_install() {
    if command_exists docker; then
        echo "Docker already installed"
    else
        echo "Installing Docker"
        sudo wget -qO- http://get.docker.com/ | sh
        sudo usermod -aG docker $USER
        newgrp docker
    fi
}

sudo apt update && sudo apt upgrade -y

docker_install

mkdir ~/jenkins

sudo chown 1000 ~/jenkins

docker compose up -d
