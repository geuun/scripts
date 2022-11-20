#!/bin/bash

# deploy.sh
# 실행조건
# deploy.sh 파일이 Project Root Directory에 위치
# 프로젝트 명 == 이미지 태그 == 컨테이너 이름 
# url, username, password => 환경변수
# sudo 권한 or docker 권한
# {
#     <ProjectName> : ${args[0]}
#     <url> : ${args[1]}
#     <username> : ${args[2]}
#     <password> : ${args[3]}
#     <port> : ${args[4]}
#     <-d> : ${args[5]}
# }
# 입력예시 
# -> springboot url root 1234 8080:8080 Y

# params 입력받기
echo "**********************************************"
echo "Please Enter The Params"
read -p "ProjectName : "  ProjectName
read -p "DB_URL : " DB_URL
read -p "DB_UserName : " DB_UserName
read -p "DB_Password : " DB_Password
read -p "Port : " Port
read -p "Daemon <Y/N> : " Daemon
echo "**********************************************"

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
        exit 1
        echo "It's the wrong option Try Again"
fi


# 최종 입력 값
echo "*****************************************************************"
echo "*** <ProjectName> <DB_URL> <DB_UserName> <DB_Password> <Port> <Deamon> ***"
echo "*****************************************************************"
echo ""
echo "Your params >>" ${ProjectName} ${DB_URL} ${DB_UserName} ${DB_Password} ${Port}  ${DemonOpt}
echo ""

# 기존 컨테이너 중지
echo "*******************************"
echo "*** Stop Existing Container ***"
echo "*******************************"
docker stop ${ProjectName}


# 기존 컨테이너 이름 변경
docker rename ${ProjectName} old${ProjectName}


# # 프로젝트 폴더 진입 (절대경로)
# echo "**************************************"
# echo "*** Entering The Project Directory ***"
# echo "**************************************"
# cd ~/dev/${ProjectName}


# git pull
echo "***********************"
echo "*** Pull repository ***"
echo "***********************"
git pull


# 이미지 빌드
ImageTag=${ProjectName}
echo "*******************"
echo "*** Build image ***"
echo "*******************"
docker build -t ${ImageTag} . 


# 컨테이너 빌드 docker run [OPTIONS] IMAGE [COMMAND] [ARG...]
echo "***********************"
echo "*** Build Container ***"
echo "***********************"
docker run ${DemonOpt} \
--name ${ProjectName} \
-p ${Port} \
-e SPRING_DATASOURCE_URL=${DB_URL} \
-e SPRING_DATASOURCE_USERNAME=${DB_UserName} \
-e SPRING_DATASOURCE_PASSWORD=${DB_Password} \
${ImageTag}

# 완료 문장
echo "##########################################################################################"
echo "###################################  Deploy is Done! #####################################"
echo "##########################################################################################"





