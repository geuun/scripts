각 역할은 다음과 같습니다.

- 파이썬 버전 관리: pyenv
- 가상환경 및 패키지 매니저: poetry

poetry의 `poetry config virtualenvs.in-project true` 옵션을 활성화 한 상태입니다.

```shell
# 프로젝트 디렉토리로 이동 후 아래 명령어 실행
$ pyenv virtualenv 3.x.x <가상환경 이름>

$ pyenv local <가상환경 이름>

$ poetry env info
>`
Virtualenv
Python:         3.x.x
Implementation: CPython
Path:           NA
Executable:     NA

Base
Platform:   linux
OS:         posix
Python:     3.x.x
Path:       /home/~
Executable: /home/~
`

$ pyenv which python
>`
/home/geun/.pyenv/versions/<가상환경 이름>/bin/python
`

$ poetry env use python
>`
Creating virtualenv <가상환경 이름> in /home/~
Using virtualenv: /home/~
`

$ poetry env info
>`
Virtualenv
Python:         3.x.x
Implementation: CPython
Path:           /home/~
Executable:     /home/~
Valid:          True

Base
Platform:   linux
OS:         posix
Python:     3.x.x
Path:       /home/{USER}/.pyenv/versions/3.x.x
Executable: /home/{USER}/.pyenv/versions/3.x.x/bin/python3.x
`

$ poetry install
>
```

위와 같이 설정하고
Base Python Interpreter는 pyenv virtualenv python 경로,
Virtualenv Python Interpreter는 프로젝트 내의 poetry 가상환경 경로로 설정하면 됩니다.
