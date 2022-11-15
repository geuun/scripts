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
echo "========================================================================================="
echo "Please Enter The Params"
echo "<ProjectName> <url> <username> <password> <port> <-d : Y/N>"
read -p ">>" -a args
echo "========================================================================================="

# # 입력 받은 값 출력
# echo "ProjectName: " ${args[0]}
# echo "url: "${args[1]}
# echo "username: "${args[2]}
# echo "password: "${args[3]}
# echo "port: "${args[4]}
# echo ""${args[5]}

# 데몬 조건문
if [ "${args[5]}" == "Y" ]
then
        DemonOpt="-d"
        echo "DemonOpt: ON"
elif [ "${args[5]}" = "N" ]
then
        DemonOpt=""
        echo "DemonOpt: OFF"
else
        exit 1
        echo "It's the wrong option Try Again"
fi


# 최종 입력 값
echo "========================================================================================="
echo "<ProjectName> <url> <username> <password> <port> <-d : Y/N>"
echo "Your params:" ${args[0]} ${args[1]} ${args[2]} ${args[3]} ${args[4]} ${DemonOpt}
echo "========================================================================================="

# 기존 컨테이너 중지
echo "========================================================================================="
echo "Stop Existing Container"
echo "========================================================================================="
docker stop ${args[0]}

# 프로젝트 폴더 진입
echo "========================================================================================="
echo "Entering The Project Directory"
echo "========================================================================================="
cd ~/dev/${args[0]}

# git pull
echo "========================================================================================="
echo "Pull repository"
echo "========================================================================================="
git pull

# 이미지 빌드
echo "========================================================================================="
echo "Build image tag:" ${args[0]}
echo "========================================================================================="
docker build -t ${args[0]} . 

# 컨테이너 빌드
echo "========================================================================================="
echo "Build Container"
echo "========================================================================================="
docker run -p ${args[4]} -e SPRING_DATASOURCE_URL=${args[1]} -e SPRING_DATASOURCE_USERNAME=${args[2]} -e SPRING_DATASOURCE_PASSWORD=${args[3]} ${DemonOpt} ${args[0]} --name ${args[0]}

# 완료 문장
echo "***********************************  Deploy is Done! **************************************"