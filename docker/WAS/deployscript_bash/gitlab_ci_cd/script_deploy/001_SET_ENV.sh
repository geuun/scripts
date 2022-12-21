#!/bin/bash

echo "#################################################################"
echo "##"
echo "##  이 스크립트는 환경변수가 휴먼에러로 인해"
echo "##  혹시 모를 Source Version 관리 시스템에 등록될 경우를 위해서"
echo "##  클라이언트의 입력을 받아서 시스템 환경변수로 등록하거나,"
echo "##  시스템 환경변수로 등록하지 않고 사용 할 수 있습니다."
echo "##  또한, Gitlab을 이용한 배포 자동화 기능도 조금 담아봤습니다 :)"
echo "##  (Spring boot 기준으로 작성되었습니다.)"
echo "##"
echo "#################################################################"

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

# Register as an Environment Variable
echo "export PROJECT_NAME="${PROJECT_NAME}"
export GIT_USERNAME="${GIT_USERNAME}"
export DB_URL="${DB_URL}"
export DB_USERNAME="${DB_USERNAME}"
export DB_PASSWORD="${DB_PASSWORD}"
export HOST_PORT="${HOST_PORT}"
export CONTAINER_PORT="${CONTAINER_PORT}"
export DAEMON_OPT="${DAEMON_OPT}"" > ./script_deploy/.env

# ${PROJECT_NAME}
# ${GIT_USERNAME}
# ${DB_URL}
# ${DB_USERNAME}
# ${DB_PASSWORD}
# ${HOST_PORT}
# ${CONTAINER_PORT}
# ${DAEMON_OPT}

# ${PROJECT_NAME}${GIT_USERNAME}${DB_URL}${DB_USERNAME}${DB_PASSWORD}${HOST_PORT}${CONTAINER_PORT}${DAEMON_OPT}