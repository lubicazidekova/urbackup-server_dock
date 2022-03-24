!/bin/bash
set -x

ARCH=${1:-amd64}
VERSION=${2:-2.4.13}

docker build \
              --build-arg ARCH=${ARCH} \
              --build-arg VERSION=${VERSION} \
              -t urbackup-server:${VERSION}_${ARCH} \
              .