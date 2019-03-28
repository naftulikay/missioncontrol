#!/usr/bin/env bash

set -euo pipefail
source /usr/lib/bash/functions.sh

COREDNS_VERSION="${COREDNS_VERSION:-latest}"

workdir="$(mktemp -d)"
cd "$workdir"

if [ "${COREDNS_VERSION}" == "latest" ]; then
  # let's autodetect the latest version
  COREDNS_VERSION="$(curl -is --head https://github.com/coredns/coredns/releases/latest | \
    grep -iP '^Location' | \
    awk '{print $2;}' | \
    python -c 'import sys;print(sys.stdin.read().split("/")[-1][1:].strip())'
  )"
fi

.log "Installing CoreDNS ${COREDNS_VERSION}..."

tar xzf <(curl -sSL https://github.com/coredns/coredns/releases/download/v${COREDNS_VERSION}/coredns_${COREDNS_VERSION}_linux_amd64.tgz)
mv ./coredns /usr/bin/coredns
chmod 0755 /usr/bin/coredns
cd / && rm -fr "${workdir}"
