# Nostr Relays - Docker Compose Edition

Production-ready dockerized deployments of Nostr relays with optional web dashboard and Tor integration.

## 🎯 Features

- **Two relay options**: nostr-rs-relay (Rust-based with dashboard & Tor) or strfry (C++-based, lightweight)
- **Web dashboard** (nostr-rs-relay only) for monitoring events and connections
- **Tor hidden service** (nostr-rs-relay only) with .onion addresses
- **Multiple deployment modes**: Local or public domain
- **Automatic HTTPS** with Let's Encrypt
- **Fully dockerized** - no external dependencies
- **Persistent databases**

## 📋 Requirements

- [Git](https://git-scm.com/), [Docker](https://www.docker.com/), [Docker Compose](https://docs.docker.com/compose/)

## 🚀 Quick Setup

### For nostr-rs-relay (Full-featured with dashboard & Tor)

1. Run the setup script:
   ```bash
   nostr-rs.bat
   ```
   This clones the repo, initializes submodules, and copies the default config.

2. Edit `config.toml` (auto-created from submodule):
   ```toml
   [info]
   name = "My Relay"
   pubkey = "your-pubkey-hex"
   description = "Relay description"
   relay_icon = "https://example.com/icon.png"
   ```

3. Configure `nostr-rs-docker-compose.yml` (optional):
   ```yaml
   caddy:
     environment:
       RELAY_DOMAIN: "localhost"
   proxy-dashboard:
     environment:
       TOR_ENABLED: false
   ```

4. Start: The script runs Docker Compose automatically after setup.

### For strfry (Lightweight alternative)

1. Run the setup script:
   ```bash
   strfry.bat
   ```
   This clones the repo and copies the default config.

2. Edit `strfry.conf` (auto-created from cloned repo):
   ```properties
   info {
       name = "My Relay"
       pubkey = "your-pubkey-hex"
       description = "Relay description"
       icon = "https://example.com/icon.png"
   }
   ```

3. Configure `strfry-docker-compose.yml` (optional):
   ```yaml
   caddy:
     environment:
       RELAY_DOMAIN: "localhost"
   ```

4. Start: The script runs Docker Compose automatically after setup.

## 🧅 Deployment Modes

| Mode | RELAY_DOMAIN | TOR_ENABLED | Access | Relay |
|------|--------------|-------------|--------|-------|
| Local | `"localhost"` | `false` | `http://localhost` | Both |
| Public Domain | `"your-domain.com"` | `false` | `https://your-domain.com` | Both |
| Tor | `"localhost"` | `true` | `http://your-address.onion` | nostr-rs-relay only |
| Public + Tor | `"your-domain.com"` | `true` | `http://your-address.onion` | nostr-rs-relay only |

**For Tor:** Get .onion address with:
```bash
docker compose exec proxy-dashboard cat /var/lib/tor/hidden_service/hostname
```

## 🏗️ Architecture

### nostr-rs-relay
```
Caddy (root) [./Caddyfile]
    ↓ HTTPS
proxy-dashboard [./proxy-dashboard/Caddyfile]
    ├─ Dashboard (React, port 3000)
    ├─ Relay proxy (port 8080)
    └─ Tor (optional)
nostr-relay (port 8080)
```

### strfry
```
Caddy (root) [./Caddyfile]
    ↓ HTTPS
strfry-relay (port 7777)
```

## 📁 Key Files

- `config.toml` - nostr-rs-relay config (auto-created)
- `strfry.conf` - strfry relay config (auto-created)
- `nostr-rs-docker-compose.yml` - nostr-rs-relay services
- `strfry-docker-compose.yml` - strfry services
- `Caddyfile` - Reverse proxy
- `proxy-dashboard/` - Dashboard (nostr-rs-relay only)
- `relay-data/` / `strfry-db/` - Databases
- `caddy-data/` - HTTPS certificates

## 🔧 Customization

### Relay Icon

For nostr-rs-relay: Update `relay_icon` in `config.toml` and place favicon in `proxy-dashboard/public/`.

For strfry: Update `icon` in `strfry.conf`.

### Custom Builds

**🛠️ nostr-rs-relay**:
The submodule points to [deymosh/nostr-rs-relay](https://github.com/deymosh/nostr-rs-relay). To use the original repo or another fork, change the submodule URL.

To change the submodule URL, use:
```
git submodule set-url <path-to-submodule> <new-repo-url>
```

#### Fork Features

- ✅ **delete events option** - Added functionality to select between hide or delete events when a kind 5 event is received.

**🛠️ strfry**:
You can replace the `strfry` directory with your own modified version of strfry if desired. Currently using the main branch of [deymosh/strfry](https://github.com/deymosh/strfry)

## 🐳 Useful Commands

```bash
# nostr-rs-relay
docker compose -f nostr-rs-docker-compose.yml up --build
docker compose logs -f nostr-relay
docker compose exec proxy-dashboard cat /var/lib/tor/hidden_service/hostname

# strfry
docker compose -f strfry-docker-compose.yml up --build
docker compose -f strfry-docker-compose.yml logs -f strfry-relay

docker compose down  # Stop all
```

## 🔐 Security

- **HTTPS**: Auto-provisioned for public domains
- **Tor v3**: Secure .onion addresses (nostr-rs-relay)
- **Data persistence**: Databases and certificates preserved

## 📝 Notes

- Generated configs (`config.toml`, `strfry.conf`) should be in `.gitignore`
- Each relay uses its own docker-compose file and database directory
- TOR_ENABLED is only available for nostr-rs-relay

## 📚 References

- [nostr-rs-relay](https://github.com/scsibug/nostr-rs-relay)
- [strfry](https://github.com/hoytech/strfry)
- [Caddy](https://caddyserver.com/) | [Tor](https://www.torproject.org/)

Happy relaying! 🚀