#!/usr/bin/env bash

set -euo pipefail
source /usr/lib/bash/functions.sh

.log "Destroying all boot scripts..."
rm -fr /etc/boot.d
