#!/bin/bash

echo "#################################################################"
echo "##                                                              ##"
echo "##  이 스크립트는 환경변수가 휴먼에러로 인해                               ##"
echo "##  혹시 모를 Source Version 관리 시스템에 등록될 경우를 위해서              ##"
echo "##  클라이언트의 입력을 받아서 시스템 환경변수로 등록하거나,                     ##"
echo "##  시스템 환경변수로 등록하지 않고 사용 할 수 있습니다.                       ##"
echo "##  또한, Gitlab을 이용한 배포 자동화 기능도 조금 담아봤습니다 :)             ##"
echo "##  (Spring boot 기준으로 작성되었습니다.)                             ##"
echo "##                                                              ##"
echo "#################################################################"

# Client 로 부터 입력 받기
echo "\n\n=====================================================================\n"
echo "Set Enviroments"
echo "Please Enter The Params"
read -p "ProjectName : " PROJECT_NAME
read -p "DB_URL : " DB_URL
read -p "DB_UserName : " DB_USERNAME
read -p "DB_Password : " DB_PASSWORD
read -p "HOST_PORT : " HOST_PORT
read -p "CONTAINER_PORT : " CONTAINER_PORT
read -p "Demon Option < Y / N > : " DAEMON
echo "\n=====================================================================\n"
########


# Check Params
echo "Check the params you entered :) "
echo -e "You enterd" 
echo ">> PROJECT_NAME : {PROJECT_NAME} \n DB_URL : {DB_URL} \n DB_USERNAME : {DB_USERNAME} \n DB_PASSWORD : {DB_PASSWORD} \n HOST_PORT : {HOST_PORT} \n CONTAINER_PORT : {CONTAINER_PORT} \n DAEMON : {DAEMON} "

echo "Are you sure? < Y / N >"
read -p ">>" 

echo "Do you want to register as an environment variable? < Y / N >"
read -p ">>"

###############

if [ ""]


# 데몬 조건문
if [ "${Daemon}" == "Y" ]
then
        DemonOpt="-d"
        echo "********************"
        echo "*** DemonOpt: ON ***"
        echo "********************"
elif [ "${Daemon}" == "N" ]
then
        DaemonOpt=""
        echo "*********************"
        echo "*** DemonOpt: OFF ***"
        echo "*********************"
else
        exit 126
        echo "It's the wrong option Try Again"
fi



export PROJECT_NAME
export DB_URL
export DB_USERNAME
export DB_PASSWORD
export HOST_PORT
export CONTAINER_PORT
export DAEMON

# 스프링부트에서 사용하는 포트
# .yml 의 server.port 정보와 동일합니다.
export SPRINGBOOT_PORT=8080

# APP_RUN.sh 에서 springboot 적용 profile 정의
# 다수개를 사용할 경우 docker, ssh 와 같은 방식으로 사용
SPRING_PROFILES_ACTIVE=docker

# WEB_RUN.sh 에서 외부에서 접근하는 포트를 정의
DOCKER_WEB_PORT=80

########## ########## ##########

# 어플리케이션 이미지 이름
export APP_IMAGE=${APP}_app_image

# 웹서버 이미지 이름
export WEB_IMAGE=${APP}_web_image

# 도커에서 불리는 어플리케이션 이름
DOCKER_APP=${APP}

# 도커에서 불리는 디비 이름
export DOCKER_DB=${APP}_db

# 도커에서 불리는 웹서버 이름
export DOCKER_WEB=${APP}_web

# network between nginx and springboot and db
export APP_NETWORK=${APP}_net

# name of springboot in docker
export DOCKER_WAS=${APP}