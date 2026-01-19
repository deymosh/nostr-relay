# Nostr Relay - Docker Compose Edition

A **production-ready** dockerized deployment of [nostr-rs-relay](https://github.com/scsibug/nostr-rs-relay) with optional Tor hidden service and web dashboard.

## 🎯 Features

- **Fully functional Nostr relay** based on nostr-rs-relay
- **Intuitive web interface** for events display
- **Optional Tor integration** with Onion hidden service
- **Multiple deployment modes** - Local, public domain, or Tor-only
- **Automatic HTTPS** with Let's Encrypt
- **Fully dockerized** - no external dependencies
- **Persistent database** with SQLite

## 📋 Requirements

- [Git](https://git-scm.com/), [Docker](https://www.docker.com/), [Docker Compose](https://docs.docker.com/compose/)

## 🧅 Deployment Modes

| Mode | RELAY_DOMAIN | TOR_ENABLED | Access |
|------|---------|---------|----------|
| Local | `"localhost"` | `false` | `http://localhost` |
| Public Domain | `"your-domain.com"` | `false` | `https://your-domain.com` |
| Tor | `"localhost"` | `true` | `http://your-address.onion` |
| Combined | `"your-domain.com"` | `true` | Both |

## 🚀 Quick Setup

### Step 1: Clone

```bash
git clone https://github.com/deymosh/nostr-relay && cd nostr-relay
git submodule update --init --recursive
```

### Step 2: Configure relay

```bash
cp nostr-rs-relay/config.toml config.toml
```

Edit `config.toml`:
```toml
[info]
name = "My Relay"
pubkey = "your-pubkey-hex"
contact = "mailto:your@email.com"

[network]
address = "0.0.0.0"
port = 8080
```

### Step 3: Configure docker-compose.yaml

```yaml
caddy:
  environment:
    RELAY_DOMAIN: "localhost"

proxy-dashboard:
  environment:
    TOR_ENABLED: false
    RELAY_HOST: "nostr-relay"
    RELAY_PORT: "8080"
```

### Step 5: Start

```bash
docker compose up --build
```

**For Tor:** The `.onion` address appears in the logs automatically:
```
[*] Hidden service hostname: your-address.onion
```

Or retrieve it anytime with:
```bash
docker compose exec proxy-dashboard cat /var/lib/tor/hidden_service/hostname
```

## 🏗️ Architecture

```
Caddy (root) [./Caddyfile]
    ↓ HTTPS certificates
proxy-dashboard [./proxy-dashboard/Caddyfile]
    ├─ React dashboard (port 3000)
    ├─ Tor optional (port 8080)
    └─ Relay proxy
nostr-relay (port 8080)
```

| Service | Purpose | Ports |
|---------|---------|-------|
| **caddy** | External reverse proxy | 80, 443 |
| **proxy-dashboard** | Dashboard & internal proxy | 3000, 8080 |
| **nostr-relay** | Relay service | 8080 |

## 📁 Key Files

- `config.toml` - Relay config
- `docker-compose.yaml` - Services config
- `Caddyfile` - External reverse proxy
- `proxy-dashboard/` - Dashboard service ([see README](proxy-dashboard/README.md))
- `relay-data/` - SQLite database
- `caddy-data/` - Certificates
- `tor-data/` - Tor keys

## 🔧 Customization

### Change relay icon

Change the `favicon.ico` file in `proxy-dashboard/public/` and reference in `config.toml`:

```toml
relay_icon = "https://your-domain.com/favicon.ico"
```

Or to your `.onion` address:
```toml
relay_icon = "http://your-address.onion/favicon.ico"
```

### Custom nostr-rs-relay build

The submodule points to my personal fork if you want to customize it. You can change the submodule to point to your own fork or the original repository.

To change the submodule URL, use:
```
git submodule set-url <path-to-submodule> <new-repo-url>
```

#### Fork Features

- ✅ **delete events option** - Added functionality to select between hide or delete events when a kind 5 event is received.

## 🐳 Useful Commands

```bash
docker compose up --build           # Start
docker compose logs -f              # View logs
docker compose logs -f nostr-relay  # Relay logs
docker compose exec proxy-dashboard cat /var/lib/tor/hidden_service/hostname  # Get .onion
docker compose down                 # Stop
```

## 🔐 Security

- **HTTPS**: Auto-provisioned by Let's Encrypt for public domains
- **Relay isolation**: Only accessible through proxy
- **Tor v3**: Most secure onion addresses
- **Data persistence**: Certificates and keys preserved

## 📚 References

- [nostr-rs-relay](https://github.com/scsibug/nostr-rs-relay)
- [Caddy](https://caddyserver.com/) | [Tor](https://www.torproject.org/)

Happy relaying! 🚀