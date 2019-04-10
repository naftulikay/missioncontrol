#!/usr/bin/env bash

set -euo pipefail
source /usr/lib/bash/functions.sh

.log "Installing NeoVim..."

export DEBIAN_FRONTEND=noninteractive

add-apt-repository -y ppa:neovim-ppa/stable >/dev/null
apt-get update >/dev/null
apt-get install -y neovim >/dev/null

# for app in vi vim editor ; do
  # update-alternatives --install /usr/bin/nvim ${app} /usr/bin/${app} 60
# done
