#!/bin/sh
set -e

echo "[*] Running as user: $(whoami)"
echo "[*] Relay domain: $RELAY_DOMAIN"
echo "[*] Relay host: $RELAY_HOST"
echo "[*] Relay port: $RELAY_PORT"
echo "[*] Tor enabled: $TOR_ENABLED"
echo "[*] Starting Proxy Dashboard..."

if [ "$TOR_ENABLED" = "true" ]; then
    echo "[*] Tor is enabled. Configuring hidden service..."
    tor -f /etc/tor/torrc &

    # Wait for Tor to create the hidden service
    echo "[*] Waiting for Tor to create the hidden service..."
    while [ ! -f /var/lib/tor/hidden_service/hostname ]; do
        sleep 2
    done

    HIDDEN_SERVICE_HOSTNAME=$(cat /var/lib/tor/hidden_service/hostname)
    echo "[*] Hidden service hostname: $HIDDEN_SERVICE_HOSTNAME"
else
    echo "[*] Tor is disabled. Skipping hidden service configuration."
fi

echo "[*] Starting Caddy..."
caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
