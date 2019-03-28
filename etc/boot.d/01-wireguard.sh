#!/usr/bin/env bash

set -euo pipefail
source /usr/lib/bash/functions.sh

WIREGUARD_ENABLED="${WIREGUARD_ENABLED:-n}"
WIREGUARD_PORT="${WIREGUARD_PORT:-51820}"
WIREGUARD_PUBLIC_KEY="${WIREGUARD_PUBLIC_KEY:-}"
WIREGUARD_PRIVATE_KEY="${WIREGUARD_PRIVATE_KEY:-}"
WIREGUARD_NET_DEVICE="${WIREGUARD_NET_DEVICE:-eth0}"
WIREGUARD_CLIENT_PUBLIC_KEYS="${WIREGUARD_CLIENT_PUBLIC_KEYS:-}"
WIREGUARD_CLIENT_ALLOWED_IPS="${WIREGUARD_CLIENT_ALLOWED_IPS:-0.0.0.0/0}"

if [ -z "$WIREGUARD_PUBLIC_KEY" -o -z "$WIREGUARD_PRIVATE_KEY" ]; then
  private_key_file="$(mktemp)"
  public_key_file="$(mktemp)"

  wg genkey | tee "$private_key_file" | wg pubkey > "$public_key_file"

  WIREGUARD_PUBLIC_KEY="$(cat "$public_key_file" && rm -f "$public_key_file")"
  WIREGUARD_PRIVATE_KEY="$(cat "$private_key_file" && rm -f "$private_key_file")"

  .log "Generated WireGuard server key as it was not provided..."
fi

# render the wireguard configuration
cat > /etc/wireguard/wgnet0.conf <<-EOF
[Interface]
Address = 0.0.0.0/0
SaveConfig = true
ListenPort = ${WIREGUARD_PORT}

PostUp   = iptables -A FORWARD -i wgnet0 -j ACCEPT; iptables -t nat -A POSTROUTING -o ${WIREGUARD_NET_DEVICE} -j MASQUERADE
PostDown = iptables -D FORWARD -i wgnet0 -j ACCEPT; iptables -t nat -D POSTROUTING -o ${WIREGUARD_NET_DEVICE} -j MASQUERADE

PrivateKey = ${WIREGUARD_PRIVATE_KEY}

EOF

# add client keys
echo "$WIREGUARD_CLIENT_PUBLIC_KEYS" | tr ':' '\n' | while read client_key ; do
  if [ -z "$client_key" ]; then
    continue
  fi

  echo -e "[Peer]\nPublicKey = ${client_key}\nAllowedIPs = ${WIREGUARD_CLIENT_ALLOWED_IPS}\n" \
    >> /etc/wireguard/wgnet0.conf
done

chmod 0600 /etc/wireguard/wgnet0.conf

.log "Rendered WireGuard configuration..."

if [ "$WIREGUARD_ENABLED" != "y" ]; then
  .log "Disabling WireGuard/BoringTun (WIREGUARD_ENABLED=${WIREGUARD_ENABLED})..."
  rm -fr /etc/service/boringtun/
else
  .log "Enabling WireGuard/BoringTun (WIREGUARD_ENABLED=${WIREGUARD_ENABLED})..."
fi
