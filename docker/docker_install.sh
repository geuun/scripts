#!/bin/bash

# Docker install
sudo wget -qO- http://get.docker.com/ | sh

# Add user to docker group (current user)
sudo usermod -aG docker ${USER}