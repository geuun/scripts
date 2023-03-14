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

# pull_image() {
#     if sh -c "docker pull $1"; then
#         echo "Pulling image $1"
#     else
#         echo "Failed to pull image $1"
#         exit 1
#     fi
# }

# run_container() {
#     if sh -c "docker run $*"; then
#         echo "# Running container"
#         echo "# Options: $*"
#     else
#         echo "# Failed to run container"
#         exit 1
#     fi
# }

sudo apt update && sudo apt upgrade -y

docker_install

## Docker-compose 방식으로 변경

# pull_image jenkins/jenkins:lts

# run_container -d -p 8080:8080 -p 50000:50000 -v /jenkins:/var/jenkins -v /home/ubuntu/.ssh:/root/.ssh -v /var/run/docker.sock:/var/run/docker.sock --name jenkins -u root jenkins/jenkins:lts

mkdir -p ~/jenkins

sudo chmod 777 ~/jenkins

docker compose up -d