#!/bin/bash

# env 주입
. ./.env

cd ${PROJECT_PATH}

# git pull
echo "***********************"
echo "*** Pull repository ***"
echo "***********************"
git pull

echo "*******************"
echo "*** Build image ***"
echo "*******************"
docker build -t ${WAS_Image_TAG} .




