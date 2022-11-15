#!/bin/bash

# deploy.sh
# 프로젝트 명 == 이미지 태그 == 컨테이너 이름 
# url, username, password => 환경변수
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
echo "Please Enter The Params"
echo "<ProjectName> <url> <username> <password> <port> <-d : Y/N>"

read -a args

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
fi


# 최종 입력 값
echo ${args[0]} ${args[1]} ${args[2]} ${args[3]} ${args[4]} ${DemonOpt}

# 기존 컨테이너 중지
docker stop ${args[0]}

# 프로젝트 폴더 진입
cd ~/dev/${args[0]}

# git pull
git pull

# 이미지 빌드
docker build -t ${args[0]} . 

# 컨테이너 빌드
docker run -p ${args[4]} -e SPRING_DATASOURCE_URL=${args[1]} -e SPRING_DATASOURCE_USERNAME=${args[2]} -e SPRING_DATASOURCE_PASSWORD=${args[3]} ${DemonOpt} ${args[0]}