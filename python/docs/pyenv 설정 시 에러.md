```shell
$ pyenv install 3.11
>`
Installing Python-3.11.9...

BUILD FAILED (Ubuntu 24.04 using python-build 2.4.7)

Inspect or clean up the working tree at /tmp/python-build.20240710132654.447254
Results logged to /tmp/python-build.20240710132654.447254.log
`
```

> 리눅스 개발 패키지 설치 필요

```shell
$ sudo apt update; sudo apt install build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev curl \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
```
