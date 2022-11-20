. ./.env

echo 'Stop Docker Container'
docker stop ${PROJECT} 

echo 'Delete Docker Container'
docker rm ${PROJECT}

echo 'Delete Docker Image'
docker rmi ${WAS_Image_TAG}




