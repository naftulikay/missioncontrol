#!/usr/bin/env bash

set -euo pipefail
source /usr/lib/bash/functions.sh

KEYBASE_USER="${KEYBASE_USER:-naftulikay}"
PGP_KEY_FINGERPRINT="${PGP_KEY_FINGERPRINT:-6D63865D1C6EEB0F92C394A15D21FFA27D8DCC66}"

.log "Creating user..."
useradd -s $(which bash) -m naftuli

.log "Installing GnuPG key..."
sudo -Hu naftuli bash -lc "gpg -q --import <(curl -sSL https://keybase.io/${KEYBASE_USER}/pgp_keys.asc)"
sudo -Hu naftuli bash -lc "echo '${PGP_KEY_FINGERPRINT}:6:' | gpg -q --batch --import-ownertrust"

.log "Installing SSH keys..."
install -o naftuli -g naftuli -m 0700 -d /home/naftuli/.ssh

curl -sSL https://secops.naftuli.wtf/ssh/keys     -o /home/naftuli/.ssh/authorized_keys
curl -sSL https://secops.naftuli.wtf/ssh/keys.asc -o /home/naftuli/.ssh/authorized_keys.asc

chmod 0600 /home/naftuli/.ssh/authorized_keys /home/naftuli/.ssh/authorized_keys.asc
chown -R naftuli:naftuli /home/naftuli/.ssh

.log "Validating SSH keys..."
sudo -Hu naftuli bash -lc 'gpg -q --verify /home/naftuli/.ssh/authorized_keys{.asc,}'

.log "Fixing ownership..."
chown -R naftuli:naftuli /home/naftuli/
