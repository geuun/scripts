# dood(Docker out of Docker)를 위한 Jenkins 이미지 생성을위한 Dockerfile

# Jenkins 공식 이미지
FROM jenkins/jenkins:2.387.1-lts-jdk11

USER root

#컨테이너 내에서 필요한 도커 설치
COPY docker_install.sh /docker_install.sh
RUN chmod +x /docker_install.sh
RUN /docker_install.sh

#설치 후 docker 그룹의 jenkins 계정 생성 후 해당 계정으로 변경
RUN groupadd -f docker
RUN usermod -aG docker jenkins
USER jenkins