#!/bin/bash

# env 주입
. ./.env

# 컨테이너 빌드 docker run [OPTIONS] IMAGE [COMMAND] [ARG...]
echo "***********************"
echo "*** Build Container ***"
echo "***********************"
docker run -d \
--name ${PROJECT} \
-p ${WAS_PORT_OPT} \
-e SPRING_DATASOURCE_URL=${DB_URL} \
-e SPRING_DATASOURCE_USERNAME=${DB_USERNAME} \
-e SPRING_DATASOURCE_PASSWORD=${DB_PASSWORD} \
${WAS_Image_TAG}




