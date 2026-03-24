#!/bin/bash
set -e

echo "=========================================="
echo "   NOSTR-RS RELAY SETUP + RUN (Linux/Mac)"
echo "=========================================="
echo ""

# Get to project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
REPO_DIR="${PROJECT_DIR}/nostr-rs-relay"
SRC_CONF="${REPO_DIR}/config.toml"
DST_CONF="${PROJECT_DIR}/config.toml"

# Step 1: Init submodule if missing
if [ ! -d "$REPO_DIR" ]; then
    echo "Initializing nostr-rs-relay submodule..."
    cd "$PROJECT_DIR"
    git submodule update --init --recursive
    if [ $? -ne 0 ]; then
        echo "Error initializing submodule"
        exit 1
    fi
else
    echo "nostr-rs-relay submodule already exists. Updating..."
    cd "$PROJECT_DIR"
    git submodule update --recursive
    if [ $? -ne 0 ]; then
        echo "Error updating submodule"
        exit 1
    fi
fi

# Step 2: Copy default config if missing
if [ ! -f "$DST_CONF" ]; then
    cp "$SRC_CONF" "$DST_CONF"
    echo "Default config copied to $DST_CONF"
else
    echo "Existing config found at \"$DST_CONF\""
fi

echo "You can edit the following values directly in the file:"
echo "- pubkey: admin pubkey (hex format)"
echo "- name: relay name"
echo "- description: relay description"
echo "- relay_icon: relay icon URL"

# Step 3: Run Docker Compose
echo ""
echo "=========================================="
echo "   Starting NOSTR-RS RELAY with Docker"
echo "=========================================="
echo ""

cd "$PROJECT_DIR"
docker compose -p nostr-rs -f docker/nostr-rs-docker-compose.yml up -d --build

if [ $? -ne 0 ]; then
    echo "Error running Docker Compose"
    exit 1
fi

# Wait for Tor to generate the onion address
echo ""
echo "Waiting for Tor to generate .onion address..."
sleep 5

ONION_ADDR=$(docker exec nostr-rs-tor cat /var/lib/tor/hidden_service/hostname 2>/dev/null | head -1)

if [ ! -z "$ONION_ADDR" ]; then
    echo ""
    echo "========================================== "
    echo "  ✓ Nostr-RS Relay is running!"
    echo "========================================== "
    echo ""
    echo "Web Interface:"
    echo "  Local:  http://localhost"
    echo "  HTTPS:  https://localhost"
    echo ""
    echo "Tor Hidden Service (.onion):"
    echo "  http://${ONION_ADDR}"
    echo ""
    echo "Nostr Relay WebSocket (default):"
    echo "  ws://localhost:8080"
    echo "  wss://localhost/ws (via reverse proxy)"
    echo ""
    echo "Note: Edit docker/Caddyfile to add custom domain"
    echo "and set TOR_ENABLED=true for full Tor setup"
    echo "========================================== "
else
    echo ""
    echo "Warning: Could not retrieve Tor onion address."
    echo "Check if Tor container is running: docker ps"
    echo "View logs: docker logs nostr-rs-tor"
fi

exit 0
