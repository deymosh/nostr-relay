# ---------- Build Stage ----------
# Use Node.js 18 on Debian Buster slim as the base image
FROM node:18-buster-slim AS builder

# Create and change to the app directory
WORKDIR /app

# Copy package.json and package-lock.json files
COPY package*.json ./
RUN npm ci

# Copy project files and folders to the current working directory (i.e. '/app')
COPY . .

# Build the project
RUN npm run build

# ---------- Final Stage ----------
# Use Debian Bookworm slim as the base image
FROM debian:bookworm-slim AS nostr-proxy-dashboard

# Set working directory
WORKDIR /app

# ---------- Install dependencies ----------
# Update package lists and install required packages
USER root
RUN apt-get update && \
    apt-get install -y curl gnupg2 lsb-release tor bash && \
    rm -rf /var/lib/apt/lists/*

# ---------- Install Caddy ----------
# Add the Caddy GPG key
RUN curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg

# Add the Caddy repository
RUN echo "deb [signed-by=/usr/share/keyrings/caddy-stable-archive-keyring.gpg] https://dl.cloudsmith.io/public/caddy/stable/deb/debian any-version main" \
    > /etc/apt/sources.list.d/caddy-stable.list

# Install Caddy
RUN apt-get update && apt-get install -y caddy && rm -rf /var/lib/apt/lists/*

# ---------- Set environment variables ----------
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

# ---------- Create tor user and hidden service directory ----------
# Create a system group and user for Tor
RUN addgroup --system tor \
    && adduser --ingroup tor --disabled-password --gecos "" --shell /bin/bash tor

# Create hidden service directory with appropriate permissions
RUN mkdir -p /var/lib/tor/hidden_service \
    && chown -R tor:tor /var/lib/tor \
    && chmod 700 /var/lib/tor /var/lib/tor/hidden_service

# ---------- Copy configuration files ----------
COPY torrc /etc/tor/torrc
COPY Caddyfile /etc/caddy/Caddyfile
COPY start.sh /start.sh
RUN chmod +x /start.sh

# ---------- Change to tor user ----------
USER tor

# Copy dashboard built from build stage
COPY --from=builder /app /app

# ---------- Expose port and command ----------
EXPOSE 80
EXPOSE 443
CMD ["/start.sh"]
