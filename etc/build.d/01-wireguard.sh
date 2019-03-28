#!/usr/bin/env bash

set -euo pipefail
source /usr/lib/bash/functions.sh

export DEBIAN_FRONTEND=noninteractive

.log "Installing WireGuard..."
apt-get update >/dev/null
apt-get install -y debconf-utils iptables software-properties-common >/dev/null
add-apt-repository -y ppa:wireguard/wireguard >/dev/null
apt-get update >/dev/null

echo 'resolvconf resolvconf/linkify-resolvconf boolean false' | \
  debconf-set-selections

apt-get install -y iproute2 resolvconf wireguard wireguard-tools >/dev/null
