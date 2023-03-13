#!/bin/bash

sudo wget -qO- http://get.docker.com/ | sh

sudo usermod -aG docker ${USER}