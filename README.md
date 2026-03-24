# Nostr Relay - Tor Edition

Docker-based Nostr relay infrastructure with Tor hidden service support. Choose between **Strfry** (C++, lightweight) or **Nostr-RS** (Rust, full-featured).

## 🎯 Features

✅ **Two relay implementations**
- **Strfry**: High-performance C++ relay
- **Nostr-RS**: Pure Rust relay

✅ **Tor hidden service integration**
- Auto-generates `.onion` addresses
- Direct relay-to-Tor routing (no intermediaries)
- Persistent onion addresses across restarts
- Recommended primary access method

✅ **Docker-based deployment**
- Fully containerized with Docker Compose
- Static IP addresses for reliable routing
- Minimal dependencies and services

## 📋 Requirements

- [Git](https://git-scm.com/)
- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/install/)

## 🚀 Quick Start

### Linux/Mac

```bash
# Strfry relay
bash utils/strfry.sh

# Or Nostr-RS relay
bash utils/nostr-rs.sh
```

### Windows

```batch
REM Strfry relay
utils\strfry.bat

REM Or Nostr-RS relay
utils\nostr-rs.bat
```

The scripts will:
1. Clone/initialize the relay repository
2. Copy default configuration
3. Start Docker containers
4. Display the `.onion` address after ~5 seconds

## 📁 Project Structure

```
├── docker/                             # Docker configuration files
│   ├── strfry-docker-compose.yml       # Strfry deployment (Relay + Tor)
│   ├── nostr-rs-docker-compose.yml     # Nostr-RS deployment (Relay + Tor)
│   ├── torrc.strfry                    # Tor config for Strfry
│   ├── torrc.nostr-rs                  # Tor config for Nostr-RS
│   └── init-tor.sh                     # Tor initialization script
│
├── utils/                              # Launch scripts
│   ├── strfry.sh / strfry.bat          # Setup and launch Strfry
│   └── nostr-rs.sh / nostr-rs.bat      # Setup and launch Nostr-RS
│
├── data/                               # Persistent volumes
│   ├── strfry-db/                      # Strfry LMDB database
│   └── nostr-rs-relay/                 # Nostr-RS SQLite database
│
├── strfry/                             # Strfry repository (cloned)
├── nostr-rs-relay/                     # Nostr-RS repository (submodule)
│
├── strfry.conf                         # Strfry relay configuration
└── config.toml                         # Nostr-RS relay configuration
```

## ⚙️ Configuration

### Edit Relay Settings

**Strfry** - Edit `strfry.conf`:
```toml
info {
    name = "Your Relay Name"
    description = "Relay description"
    pubkey = "your-pubkey-hex"
    icon = "https://example.com/icon.png"
}
```

**Nostr-RS** - Edit `config.toml`:
```toml
[info]
name = "Your Relay Name"
description = "Relay description"
pubkey = "your-pubkey-hex"
relay_icon = "https://example.com/icon.png"
```

## 🧅 Accessing Your Relay

### Via Tor (Recommended)

The `.onion` address is displayed when the relay starts:
```
ws://XXXXXXXXXXXXXX.onion
```

Connect using a Tor client or browser (Tor Browser):
```bash
# For Strfry
ws://XXXXXXXXXXXXXX.onion

# For Nostr-RS
ws://XXXXXXXXXXXXXX.onion
```

### Local/Clearnet Access (Optional)

The relay also listens on local ports (optional clearnet access):
```bash
# Strfry
ws://localhost:7777

# Nostr-RS
ws://localhost:8080
```

To enable external clearnet access, modify the docker-compose port mappings.

## 🏗️ Architecture

### Docker Compose Services

Each relay deployment consists of 2 services:

1. **Relay Service** (Strfry or Nostr-RS)
   - Image built from repository
   - Static IP: `172.20.0.2`
   - Listens on port 7777 (Strfry) or 8080 (Nostr-RS)
   - WebSocket protocol

2. **Tor Service**
   - Image: `lncm/tor:latest`
   - Static IP: `172.20.0.3`
   - Runs as root (required for directory permissions)
   - Redirects hidden service port 80 to relay (172.20.0.2:7777/8080)

### Network Layout

```
Network: 172.20.0.0/16 (nostr-relay-net)
├── Relay:  172.20.0.2 (port 7777/8080)
└── Tor:    172.20.0.3 (SOCKS5 on 9050)
```

## 📊 Managing Relays

### View Logs

```bash
# Strfry relay logs
docker compose -p strfry -f docker/strfry-docker-compose.yml logs -f strfry-relay

# Strfry Tor logs
docker compose -p strfry -f docker/strfry-docker-compose.yml logs -f tor

# Nostr-RS relay logs
docker compose -p nostr-rs -f docker/nostr-rs-docker-compose.yml logs -f nostr-rs-relay

# Nostr-RS Tor logs
docker compose -p nostr-rs -f docker/nostr-rs-docker-compose.yml logs -f tor
```

### Get .onion Address

```bash
# Strfry
docker exec strfry-tor cat /var/lib/tor/hidden_service/hostname

# Nostr-RS
docker exec nostr-rs-tor cat /var/lib/tor/hidden_service/hostname
```

### Restart Relay

```bash
# Strfry
docker compose -p strfry -f docker/strfry-docker-compose.yml restart

# Nostr-RS
docker compose -p nostr-rs -f docker/nostr-rs-docker-compose.yml restart
```

### Stop Relay

```bash
# Strfry
docker compose -p strfry -f docker/strfry-docker-compose.yml down

# Nostr-RS
docker compose -p nostr-rs -f docker/nostr-rs-docker-compose.yml down
```

### Clean Everything (Remove Containers & Volumes)

```bash
# Strfry
docker compose -p strfry -f docker/strfry-docker-compose.yml down -v

# Nostr-RS
docker compose -p nostr-rs -f docker/nostr-rs-docker-compose.yml down -v
```

## 🛠️ Troubleshooting

### Tor not generating .onion address

```bash
# Check Tor logs (Strfry example)
docker logs strfry-tor

# View directory structure
docker exec strfry-tor ls -la /var/lib/tor/hidden_service/

# Verify permissions
docker exec strfry-tor ls -la /var/lib/tor/
```

### Relay not responding

```bash
# Check relay logs
docker logs strfry-relay       # For Strfry
docker logs nostr-rs-relay    # For Nostr-RS

# Test connectivity (from host)
nc -zv localhost 7777          # Strfry
nc -zv localhost 8080          # Nostr-RS

# Check relay info (NIP-11)
curl http://localhost:7777 -H "Accept: application/nostr+json"
```

### Port conflicts

If ports 7777 or 8080 are already in use:

1. Stop other services using those ports
2. Or modify docker-compose port mappings (e.g., `8000:7777` instead of `7777:7777`)

## 🔐 Security Recommendations

- Set proper `pubkey` in configs for admin contact
- Use strong configuration passwords if implementing NIP-42 authentication
- Keep Docker and system updated
- Monitor disk space for database growth
- Enable firewall rules to restrict clearnet access if needed
- Consider Tor as the primary access method for privacy

## 📚 References

- **Strfry**: https://github.com/hoytech/strfry
- **Nostr-RS**: https://github.com/scsibug/nostr-rs-relay
- **Tor**: https://www.torproject.org/
- **Nostr Protocol**: https://github.com/nostr-protocol/nips