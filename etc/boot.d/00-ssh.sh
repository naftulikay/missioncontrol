#!/usr/bin/env bash

set -euo pipefail
source /usr/lib/bash/functions.sh

SSH_ED25519_PUBLIC_KEY="${SSH_ED25519_PUBLIC_KEY:-}"
SSH_ED25519_PRIVATE_KEY="${SSH_ED25519_PRIVATE_KEY:-}"

if [ ! -z "$SSH_ED25519_PUBLIC_KEY" ]; then
  .log "Installing provided SSH public key..."
  echo "$SSH_ED25519_PUBLIC_KEY" > /etc/ssh/ssh_host_ed25519_key.pub
  chmod 0600 /etc/ssh/ssh_host_ed25519_key.pub
fi

if [ ! -z "$SSH_ED25519_PRIVATE_KEY" ]; then
  .log "Installing provided SSH private key..."
  echo "$SSH_ED25519_PRIVATE_KEY" > /etc/ssh/ssh_host_ed25519_key
  chmod 0600 /etc/ssh/ssh_host_ed25519_key
fi

if [ -z "$SSH_ED25519_PUBLIC_KEY" -o -z "$SSH_ED25519_PRIVATE_KEY" ]; then
  .log "Generating SSH public and private keys as they were not provided..."
  ssh-keygen -q -N "" -t ed25519 -f /etc/ssh/ssh_host_ed25519_key
  chmod 0600 /etc/ssh/ssh_host_ed25519_key
fi

# create sshd work directory
mkdir -p /run/sshd
