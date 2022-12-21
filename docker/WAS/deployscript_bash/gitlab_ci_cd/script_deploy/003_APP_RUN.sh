#!/bin/bash

bash ./script_deploy/.env

ENV_CONTENTS=$(${PROJECT_NAME}${GIT_USERNAME}${DB_URL}${DB_USERNAME}${DB_PASSWORD}${HOST_PORT}${CONTAINER_PORT}${DAEMON_OPT})
DOCKER_RUN_COMMEND=$(docker run ${DAEMON_OPT} --name ${PROJECT_NAME} -p ${HOST_PORT}:${CONTAINER_PORT} -e SPRING_DATASOURCE_URL=${DB_URL} -e SPRING_DATASOURCE_USERNAME=${DB_UserName} -e SPRING_DATASOURCE_PASSWORD=${DB_Password} registry.gitlab.com/${GIT_USERNAME}/${PROJECT_NAME}:latest)

echo ""
echo "Start deploying "
echo ""

if echo ${ENV_CONTENTS} | grep "" ;
then
    echo ""
    echo "Environment variables is not set"
    echo "If you didn't run '001_SET_ENV', please run '001_SET_ENV'"
    echo ""
    exit 1
fi

if ${DOCKER_RUN_COMMEND} | grep "docker: Error" ;
then
    echo ""
    echo "Stop the previous docker container"
    docker stop ${PROJECT_NAME}
    echo "Delete the previous docker container"
    docker rm ${PROJECT_NAME}
    echo ""
fi


echo "Deployment Complete !"
echo "Remove Docker-Image that have <none> status"

# docker <none> image 전부 삭제
docker rmi $(docker images -f "dangling=true" -q)

echo "ALL PROCESSES ARE DONE !"
