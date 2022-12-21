#!/bin/bash

#################################################################"
##"
##  이 스크립트는 환경변수가 휴먼에러로 인해"
##  혹시 모를 Source Version 관리 시스템에 등록될 경우를 위해서"
##  클라이언트의 입력을 받아서 시스템 환경변수로 등록하거나,"
##  시스템 환경변수로 등록하지 않고 사용 할 수 있습니다."
##  또한, Gitlab을 이용한 배포 자동화 기능도 조금 담아봤습니다 :)"
##  (Spring boot 기준으로 작성되었습니다.)"
##"
#################################################################"

###############
# Client 로 부터 입력 받기
echo -e "\n\n=====================================================================\n"
echo "Set Enviroments"
echo "Please Enter The Params"
read -p "ProjectName : " PROJECT_NAME
read -p "GIT_USERNAME : " GIT_USERNAME
read -p "DB_URL : " DB_URL
read -p "DB_UserName : " DB_USERNAME
read -p "DB_Password : " DB_PASSWORD
read -p "HOST_PORT : " HOST_PORT
read -p "CONTAINER_PORT : " CONTAINER_PORT
read -p "Demon Option < Y / N > : " DAEMON
echo "\n=====================================================================\n"
###############

###############
# Check Params
echo "Check the params you entered :) "
echo -e "You enterd" 
echo -e ">> PROJECT_NAME : ${PROJECT_NAME} \n GIT_USERNAME : ${GIT_USERNAME} \n DB_URL : ${DB_URL} \n DB_USERNAME : ${DB_USERNAME} \n DB_PASSWORD : ${DB_PASSWORD} \n HOST_PORT : ${HOST_PORT} \n CONTAINER_PORT : ${CONTAINER_PORT} \n DAEMON : ${DAEMON} "

echo "If you answer Y, the variables entered are registered as environment variablesAnd used to deploy."
echo "Are you sure? < Y / N >"
read -p ">> " CLIENT_RESPONSE

while [ true ]
do
        if [ "${CLIENT_RESPONSE}" == "Y" ]
        then
                break
        else
                echo "Your answer 'N' or You put the wrong input"
                exit 1
        fi
done

###############

###############
# 데몬 조건문
if [ "${DAEMON}" == "Y" ]
then
        DAEMON_OPT="-d"
elif [ "${DAEMON}" == "N" ]
then
        DAEMON_OPT=""
else
        echo "It's the wrong option Try Again"
        exit 1
fi

###############

PULLCONTENTS=$(docker pull registry.gitlab.com/${GIT_USERNAME}/${PROJECT_NAME})

echo "Deploy Registry URL : ${PULLCONTENTS}"

if echo ${PULLCONTENTS} | grep "Image is up to date" ;
then
        echo "Image already up to date."
        echo "Stop the build."
        exit 0
fi

echo ""
echo "Code changed :)"

###############

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

###############

if crontab -l | grep "nohup */10 * * * * bash ./RUN_CD >> ./deploy.log 2>&1 &" ;
then
    echo "Crontab already set !"
    echo "So Stop Crontab Setting :)"
    exit 0
fi

# 
touch ./deploy.log

# 10분마다 실행하는 Crontab을 새로 등록 및 로그 저장
# ex) cat <(crontab -l) <(echo "nohup 0,30 * * * * bash ./deploy.sh >> ./deploy.log 2>&1 &") | crontab
cat <(crontab -l) <(echo "nohup */10 * * * * bash ./RUN_CD >> ./deploy.log 2>&1 &") | crontab