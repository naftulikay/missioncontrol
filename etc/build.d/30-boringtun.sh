#!/usr/bin/env bash

set -euo pipefail
source /usr/lib/bash/functions.sh

.log "Installing BoringTun..."
sudo -Hu naftuli bash -lc 'cargo install -q boringtun'
install -o root -g root -m 0755 /home/naftuli/.cargo/bin/boringtun /usr/local/sbin/boringtun
