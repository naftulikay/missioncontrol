#!/usr/bin/env bash

set -euo pipefail
source /usr/lib/bash/functions.sh

.log "Rendering /etc/resolv.conf..."

# TODO inject nameservers into CoreDNS for resolution of search domains; any queries to a search domain must use these
#      resolvers rather than going over WAN to Cloudflare
search_domains="$(grep -oP '(?<=^search\s).*$' /etc/resolv.conf)"
nameservers="$(grep -oP '(?<=^nameserver\s).*$' /etc/resolv.conf)"

.log "Found Nameservers: ${nameservers}"
.log "Found Search Domains: ${search_domains}"

cat > /etc/resolv.conf <<-EOF
search ${search_domains}
nameserver 127.0.0.1
$(
echo "$nameservers" | while read nameserver ; do
  echo "nameserver ${nameserver}"
done
)
EOF
