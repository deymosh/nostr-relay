# Nostr Relay Proxy & Dashboard

A **flexible proxy and web dashboard** for your Nostr relay with optional Tor integration.

## 🎯 Features

- **Web Dashboard** - Monitor relay events and connections
- **Optional Tor Hidden Service** - Generate `.onion` addresses
- **Internal Caddy Reverse Proxy** - WebSocket handling, relay routing
- **Persistent Storage** - Tor keys and data

## 🔧 Architecture

This service handles:

| Component | Purpose | Port |
|-----------|---------|------|
| **Internal Caddy** | Routes traffic, WebSocket support | 3000, 8080 |
| **Tor** | Optional hidden service | 8080 |
| **React Dashboard** | Web interface | 3000 |

**Flow:**
```
External Caddy (root)
    ↓
proxy-dashboard:3000 [./Caddyfile]
    ├─→ Dashboard (React)
    ├─→ Relay (WebSocket)
    └─→ Tor (optional)
```

## 📋 Configuration

Set in `docker-compose.yaml`:

```yaml
proxy-dashboard:
  environment:
    TOR_ENABLED: false            # true/false
    RELAY_HOST: "nostr-relay"     # Container hostname
    RELAY_PORT: "8080"            # Match relay config
```

## 🧅 Tor Hidden Service

**Enable:** Set `TOR_ENABLED: true` in docker-compose.yaml

**Get address:** During startup, appears automatically in logs:
```
[*] Hidden service hostname: your-address.onion
```

Or retrieve it anytime with:
```bash
docker compose exec proxy-dashboard cat /var/lib/tor/hidden_service/hostname
```

## 📁 This Submodule Contains

- `Caddyfile` - Internal reverse proxy configuration
- `start.sh` - Entry point (configures Tor, starts Caddy)
- `Dockerfile` - Multi-stage build with Caddy + Tor + React
- `src/` - React dashboard source
- `public/` - Static assets

## 🔐 Security Features

- **WebSocket routing** - Secure relay proxy
- **Tor v3** - Most secure onion addresses
- **Network isolation** - Docker network communication only

See main [README](../README.md) for complete setup and features.

Happy relaying! 🚀