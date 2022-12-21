#!/bin/bash

bash ./script_deploy/.env

PULLCONTENTS="docker pull registry.gitlab.com/${GIT_USERNAME}/${PROJECT_NAME}"

echo "Deploy Registry URL : ${PULLCONTENTS}"

if echo ${PULLCONTENTS} | grep "Image is up to date" ;
then
        echo "Image already up to date."
        echo "Stop the build."
        exit 0
fi

echo ""
echo "Code changed :)"