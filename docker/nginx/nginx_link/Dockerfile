#Dockerfile
FROM nginx:latest

# nginx config 파일 복사
COPY nginx.conf /etc/nginx/nginx/conf
COPY {appname}.conf /etc/nginx/sites-available/

# 이미지 빌드 전 실행될 커맨드 입력
# nginx conf files 심볼릭 링크거는 작업
RUN mkdir -p /etc/nginx/sites-enabled/\
     && ln -s /etc/nginx/sites-available/{appname}.conf /etc/nginx/sites-enabled/
 
 
 
# 컨테이너 시작시 실행할 커맨드 입력
CMD ["nginx"]
 
# 포트
EXPOSE 80
EXPOSE 443