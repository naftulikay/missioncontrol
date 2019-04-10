#!/usr/bin/env bash

set -euo pipefail
source /usr/lib/bash/functions.sh

export DEBIAN_FRONTEND=noninteractive

.log "Upgrading all packages..."
apt-get update >/dev/null
apt-get upgrade -y >/dev/null

.log "Cleaning apt..."
rm -fr /var/lib/apt/lists/*
apt-get clean

.log "Removing pregenerated SSH host keys..."
find /etc/ssh/ -type f \
  \( -iname 'ssh_host_*_key' -or \
      -iname 'ssh_host_*_key.pub' -or \
      -iname 'moduli' \
  \) -delete

.log "Removing build scripts..."
rm -fr /etc/build.d
