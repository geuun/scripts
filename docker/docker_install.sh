#!/usr/bin/env bash
#
# install-docker.sh — Docker Engine 설치 스크립트
#
# 지원: Rocky / AlmaLinux / RHEL / CentOS Stream / Fedora / Oracle Linux
#       Ubuntu / Debian
#
# - https://docs.docker.com/engine/install/centos/
# - https://docs.docker.com/engine/install/ubuntu/
#
# 사용법:
#   ./install-docker.sh                 # 필요시 자동으로 sudo 재실행
#   sudo ./install-docker.sh
#   DOCKER_USER=deploy ./install-docker.sh    # 특정 계정을 docker 그룹에 추가
#   RUN_HELLO_WORLD=0 ./install-docker.sh     # 검증용 컨테이너 실행 생략
#
set -Eeuo pipefail

DOCKER_PKGS=(docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin)
# https://docs.docker.com/engine/install/centos/ 에 명시된 공식 키 지문
EXPECTED_FPR="060A61C51B558A7F742B77AAC52FEB6B621E9F35"
RUN_HELLO_WORLD="${RUN_HELLO_WORLD:-1}"

log()  { printf '\033[1;32m[+]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[!]\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31m[x]\033[0m %s\n' "$*" >&2; exit 1; }
on_err() {
  local rc=$?
  printf '\033[1;31m[x]\033[0m line %s 에서 실패했습니다. (exit=%s)\n' "${BASH_LINENO[0]}" "${rc}" >&2
  exit "${rc}"
}
trap on_err ERR

# ---------------------------------------------------------------- 사전 준비 --

require_root() {
  [[ ${EUID} -eq 0 ]] && return 0
  command -v sudo >/dev/null 2>&1 || die "root 권한이 필요한데 sudo가 없습니다."
  log "root 권한이 필요하여 sudo로 재실행합니다."
  exec sudo env \
    DOCKER_USER="${DOCKER_USER:-$(id -un)}" \
    RUN_HELLO_WORLD="${RUN_HELLO_WORLD}" \
    bash "$0" "$@"
}

detect_os() {
  [[ -r /etc/os-release ]] || die "/etc/os-release 가 없어 배포판을 판별할 수 없습니다."
  # shellcheck disable=SC1091
  . /etc/os-release
  OS_ID="${ID:-unknown}"
  OS_LIKE="${ID_LIKE:-}"
  OS_NAME="${PRETTY_NAME:-${OS_ID}}"

  case " ${OS_ID} ${OS_LIKE} " in
    *" fedora "*|*" rhel "*|*" centos "*) FAMILY="rhel" ;;
    *" debian "*|*" ubuntu "*)            FAMILY="debian" ;;
    *) die "지원하지 않는 배포판입니다: ${OS_NAME}" ;;
  esac

  # Rocky·Alma·Oracle 은 CentOS 저장소를 그대로 사용한다 (공식 문서 기준)
  case "${OS_ID}" in
    fedora) REPO_DISTRO="fedora" ;;
    rhel)   REPO_DISTRO="rhel" ;;
    *)      REPO_DISTRO="centos" ;;
  esac

  log "감지된 시스템: ${OS_NAME} (family=${FAMILY})"
}

# ------------------------------------------------------------- RHEL 계열 --

# dnf5(Rocky 10, Fedora 41+)와 dnf4(Rocky 8/9)의 문법이 달라 둘 다 처리한다.
add_repo_rhel() {
  local url="https://download.docker.com/linux/${REPO_DISTRO}/docker-ce.repo"

  if [[ -f /etc/yum.repos.d/docker-ce.repo ]]; then
    log "docker-ce 저장소가 이미 등록되어 있습니다."
    return 0
  fi

  log "Docker 공식 저장소 추가: ${url}"
  dnf config-manager --add-repo "${url}" 2>/dev/null \
    || dnf config-manager addrepo --from-repofile="${url}" \
    || die "저장소 추가 실패"
}

# RHEL 계열에서 $releasever 가 '9.4' 처럼 마이너 버전까지 잡히면
# download.docker.com 경로가 없어 404가 난다. 메이저 버전으로 고정한다.
pin_releasever() {
  local repo="/etc/yum.repos.d/docker-ce.repo" major
  [[ -f ${repo} ]] || return 0
  major="$(rpm -E '%{rhel}' 2>/dev/null || true)"
  [[ ${major} =~ ^[0-9]+$ ]] || return 0
  grep -q '\$releasever' "${repo}" || return 0

  log "저장소의 \$releasever 를 ${major} 로 고정합니다."
  sed -i 's/\$releasever/'"${major}"'/g' "${repo}"
}

# GPG 키를 미리 검증·등록해서 설치 중 대화형 확인을 없앤다.
import_gpg_key() {
  local repo="/etc/yum.repos.d/docker-ce.repo" key_url tmp fpr
  key_url="$(awk -F= '/^[[:space:]]*gpgkey/{print $2; exit}' "${repo}" | tr -d ' ')"
  [[ -n ${key_url} ]] || { warn "gpgkey 항목을 찾지 못해 검증을 건너뜁니다."; return 0; }

  tmp="$(mktemp)"
  if ! curl -fsSL "${key_url}" -o "${tmp}"; then
    rm -f "${tmp}"
    warn "GPG 키 다운로드 실패, 검증을 건너뜁니다."
    return 0
  fi

  if command -v gpg >/dev/null 2>&1; then
    fpr="$(gpg --show-keys --with-colons "${tmp}" 2>/dev/null | awk -F: '/^fpr:/{print $10; exit}')"
    if [[ ${fpr} != "${EXPECTED_FPR}" ]]; then
      rm -f "${tmp}"
      die "GPG 키 지문 불일치! 기대=${EXPECTED_FPR} 실제=${fpr:-없음}"
    fi
    log "GPG 키 지문 확인 완료 (${EXPECTED_FPR})"
  fi
  rpm --import "${tmp}"
  rm -f "${tmp}"
}

install_rhel() {
  command -v curl >/dev/null 2>&1 || dnf -y install curl

  log "충돌 가능한 구버전 패키지 제거"
  dnf -y remove docker docker-client docker-client-latest docker-common \
                docker-latest docker-latest-logrotate docker-logrotate \
                docker-engine podman-docker >/dev/null 2>&1 || true

  log "dnf-plugins-core 설치"
  dnf -y install dnf-plugins-core

  add_repo_rhel
  pin_releasever
  import_gpg_key

  log "Docker Engine 설치: ${DOCKER_PKGS[*]}"
  dnf -y install "${DOCKER_PKGS[@]}"
}

# ----------------------------------------------------------- Debian 계열 --

install_debian() {
  export DEBIAN_FRONTEND=noninteractive
  local codename

  log "충돌 가능한 구버전 패키지 제거"
  for p in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
    apt-get -y remove "$p" >/dev/null 2>&1 || true
  done

  apt-get update -qq
  apt-get -y install ca-certificates curl gnupg

  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL "https://download.docker.com/linux/${OS_ID}/gpg" \
    -o /etc/apt/keyrings/docker.asc
  chmod a+r /etc/apt/keyrings/docker.asc

  codename="${VERSION_CODENAME:-${UBUNTU_CODENAME:-}}"
  [[ -n ${codename} ]] || die "배포판 코드네임을 확인할 수 없습니다."

  cat >/etc/apt/sources.list.d/docker.list <<EOF
deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/${OS_ID} ${codename} stable
EOF

  apt-get update -qq
  log "Docker Engine 설치: ${DOCKER_PKGS[*]}"
  apt-get -y install "${DOCKER_PKGS[@]}"
}

# -------------------------------------------------------------- 설치 후 --

enable_service() {
  # RPM 계열은 설치만으로 데몬이 시작되지 않는다. 반드시 직접 켜야 한다.
  if command -v systemctl >/dev/null 2>&1 && [[ -d /run/systemd/system ]]; then
    log "docker 서비스 활성화 및 시작"
    systemctl enable --now docker
  else
    warn "systemd 환경이 아니어서 서비스 자동 시작을 건너뜁니다."
  fi
}

add_user_to_docker_group() {
  local user="${DOCKER_USER:-${SUDO_USER:-}}"

  if [[ -z ${user} || ${user} == "root" ]]; then
    warn "docker 그룹에 추가할 일반 사용자가 없습니다. (DOCKER_USER=계정명 으로 지정 가능)"
    return 0
  fi
  id "${user}" >/dev/null 2>&1 || die "사용자 '${user}' 가 존재하지 않습니다."

  getent group docker >/dev/null || groupadd docker

  if id -nG "${user}" | tr ' ' '\n' | grep -qx docker; then
    log "'${user}' 는 이미 docker 그룹 소속입니다."
  else
    log "'${user}' 를 docker 그룹에 추가"
    usermod -aG docker "${user}"
    GROUP_CHANGED="${user}"
  fi
}

verify_install() {
  log "설치 검증"
  docker --version
  docker compose version || warn "docker compose 플러그인 확인 실패"

  if [[ ${RUN_HELLO_WORLD} == "1" ]]; then
    if docker run --rm hello-world >/dev/null 2>&1; then
      log "hello-world 컨테이너 실행 성공"
    else
      warn "hello-world 실행 실패 (네트워크·레지스트리 접근을 확인하세요)"
    fi
  fi
}

# ------------------------------------------------------------------ main --

main() {
  require_root "$@"
  detect_os

  case "${FAMILY}" in
    rhel)   install_rhel ;;
    debian) install_debian ;;
  esac

  enable_service
  add_user_to_docker_group
  verify_install

  echo
  log "Docker 설치가 완료되었습니다."
  if [[ -n ${GROUP_CHANGED:-} ]]; then
    warn "'${GROUP_CHANGED}' 의 그룹 변경은 재로그인 후 적용됩니다."
    warn "지금 바로 적용하려면: newgrp docker"
  fi
}

main "$@"
