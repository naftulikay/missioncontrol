#!/usr/bin/env bash

set -euo pipefail
source /usr/lib/bash/functions.sh

export DEBIAN_FRONTEND=noninteractive

.log "Installing system packages..."

apt-get update >/dev/null
apt-get install -y apt-utils >/dev/null
apt-get install -y bash bash-completion build-essential curl dnsutils gnupg knot-dnsutils less libcap2-bin mosh netcat \
  net-tools nmap openssh-server openssh-client psmisc runit sudo traceroute tree tmux >/dev/null
