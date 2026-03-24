#!/bin/sh
# Initialize Tor data directory with correct permissions (run as root)
mkdir -p /var/lib/tor/hidden_service
chmod 700 /var/lib/tor
chmod 700 /var/lib/tor/hidden_service

# Find tor executable
TOR_BIN=$(which tor)
if [ -z "$TOR_BIN" ]; then
    # Try common locations
    for path in /usr/bin/tor /bin/tor /usr/local/bin/tor; do
        if [ -x "$path" ]; then
            TOR_BIN="$path"
            break
        fi
    done
fi

if [ -z "$TOR_BIN" ]; then
    echo "Error: Tor executable not found"
    exit 1
fi

# Start Tor as root (container is sandboxed)
exec "$TOR_BIN" -f /etc/tor/torrc
