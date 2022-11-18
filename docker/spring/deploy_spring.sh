#!/bin/bash

# deploy.sh
# 실행조건
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
echo "***********************"
echo "Please Enter The Params"
echo "<ProjectName> <url> <username> <password> <port> <-d : Y/N>"
read -p “ProjectName : ” ProjectName
read -p “URL : ” URL
read -p “UserName : ” UserName
read -p “Password : ” Password
read -p “Port : ” Port
read -p “Daemon <Y/N> : ” Daemon
echo "***********************"

# # 입력 받은 값 출력
# echo "ProjectName: " ${args[0]}
# echo "url: "${args[1]}
# echo "username: "${args[2]}
# echo "password: "${args[3]}
# echo "port: "${args[4]}
# echo ""${args[5]}

# 데몬 조건문
if [ "${daemon}" == "Y" ]
then
        DemonOpt="-d"
        echo "DemonOpt: ON"
elif [ "${daemon}" = "N" ]
then
        DaemonOpt=""
        echo "DemonOpt: OFF"
else
        exit 1
        echo "It's the wrong option Try Again"
fi


# 최종 입력 값
echo "*****************************************************************"
echo "*** <ProjectName> <url> <username> <password> <port> <Deamon> ***"
echo "*****************************************************************"
echo ""
echo "Your params >>" ${ProjectName} ${URL} ${UserName} ${Password} ${Port}  ${DemonOpt}
echo ""

# 기존 컨테이너 중지
echo "*******************************"
echo "*** Stop Existing Container ***"
echo "*******************************"
docker stop ${ProjectName}


# 기존 컨테이너 이름 변경
docker rename ${ProjectName} old${ProjectName}


# 프로젝트 폴더 진입 (절대경로)
echo "**************************************"
echo "*** Entering The Project Directory ***"
echo "**************************************"
cd ~/dev/${ProjectName}


# git pull
echo "***********************"
echo "*** Pull repository ***"
echo "***********************"
git pull


# 이미지 빌드
echo "*******************"
echo "*** Build image ***"
echo "*******************"
docker build -t ${ProjectName} . 


# 컨테이너 빌드 docker run [OPTIONS] IMAGE [COMMAND] [ARG...]
echo "***********************"
echo "*** Build Container ***"
echo "***********************"
docker run ${DemonOpt} --name ${ProjectName} -p ${Port} -e SPRING_DATASOURCE_URL=${URL} -e SPRING_DATASOURCE_USERNAME=${UserName} -e SPRING_DATASOURCE_PASSWORD=${Password} ${DaemonOpt}

# 완료 문장
echo "##########################################################################################"
echo "###################################  Deploy is Done! #####################################"
echo "##########################################################################################"


