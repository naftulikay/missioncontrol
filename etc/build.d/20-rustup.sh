#!/usr/bin/env bash

set -euo pipefail
source /usr/lib/bash/functions.sh

.log "Installing Rustup..."
curl -sSf https://sh.rustup.rs | sudo -Hu naftuli sh -s -- -y

.log "Installing Rust Bash completions..."
sudo -Hu naftuli bash -lc 'rustup completions bash' > /etc/bash_completion.d/rust.sh

# add that shit to path
cat > /etc/profile.d/rust.sh <<-EOF
#/usr/bin/env bash

export PATH="\$HOME/.cargo/bin:\$PATH"
EOF
