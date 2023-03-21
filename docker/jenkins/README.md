# Jenkins with Docker

> dood 방식을 사용하여 Jenkins를 실행하는 스크립트입니다.

### 1. jenkins + docker 설치 및 container 생성

docker 설치 유무를 판단 후 jenkins 컨테이너를 실행합니다.

```bash
$ sudo bash ./jenkins_init.sh
```

### 2. Jenkins Container 삭제

```bash
$ sudo bash ./jenkins_remove.sh
```

### 참고

1. Jenkins 공식이미지의 volume 권한 오류

> 공식이미지에 volume 설정 권한 오류가 있는 것 같습니다. [참고](https://github.com/jenkinsci/docker/issues/177)
> 따라서 shell script를 이용하지 않는다면, jenkins volume을 설정할 디렉토리를 직접 생성 후 권한 설정을 해주어야합니다.
