#!/bin/bash
# =============================================================================
# Minecraft Server — Full Install Script
# =============================================================================
# Usage:
#   1. cp .env.example .env
#   2. nano .env   (fill in your values)
#   3. sudo bash install.sh
# =============================================================================

set -e

# -----------------------------------------------------------------------------
# Colors and logging
# -----------------------------------------------------------------------------

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info()    { echo -e "${CYAN}[INFO]${NC} $*"; }
log_ok()      { echo -e "${GREEN}[ OK ]${NC} $*"; }
log_warn()    { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error()   { echo -e "${RED}[ERR ]${NC} $*" >&2; }
log_section() { echo -e "\n${CYAN}==============================${NC}\n${CYAN} $*${NC}\n${CYAN}==============================${NC}"; }

# -----------------------------------------------------------------------------
# Checks
# -----------------------------------------------------------------------------

check_root() {
  if [ "$EUID" -ne 0 ]; then
    log_error "This script must be run as root or with sudo."
    exit 1
  fi
}

check_env() {
  if [ ! -f ".env" ]; then
    log_error ".env file not found."
    log_error "Copy .env.example to .env and fill in your values first:"
    log_error "  cp .env.example .env && nano .env"
    exit 1
  fi
  source .env
  log_ok ".env loaded"
}

check_debian() {
  if ! grep -qi debian /etc/os-release 2>/dev/null; then
    log_warn "This script is designed for Debian. Proceeding anyway..."
  else
    log_ok "Debian detected"
  fi
}

# -----------------------------------------------------------------------------
# Step 1 — Debian base
# -----------------------------------------------------------------------------

step_debian() {
  log_section "Step 1 — Debian base setup"

  log_info "Installing sudo..."
  apt-get install -y sudo
  usermod -aG sudo "$ADMIN_USER"
  log_ok "User $ADMIN_USER added to sudo group"

  log_info "Configuring static IP via dhcpcd..."
  if ! grep -q "interface $WIFI_INTERFACE" /etc/dhcpcd.conf 2>/dev/null; then
    cat >> /etc/dhcpcd.conf << DHCP

interface $WIFI_INTERFACE
static ip_address=$SERVER_IP/24
static routers=$GATEWAY_IP
static domain_name_servers=8.8.8.8 1.1.1.1
DHCP
    log_ok "dhcpcd configured"
  else
    log_warn "dhcpcd already configured for $WIFI_INTERFACE, skipping"
  fi

  log_info "Configuring /etc/network/interfaces..."
  cat > /etc/network/interfaces << IFACE
source /etc/network/interfaces.d/*

auto lo
iface lo inet loopback

auto $WIFI_INTERFACE
iface $WIFI_INTERFACE inet static
    address $SERVER_IP
    netmask 255.255.255.0
    gateway $GATEWAY_IP
    wpa-ssid $WIFI_SSID
    wpa-psk $WIFI_PASSWORD
IFACE
  log_ok "network/interfaces configured"

  log_info "Disabling laptop sleep/suspend..."
  systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
  log_ok "Sleep targets masked"

  log_info "Updating system and installing base packages..."
  apt-get update -qq
  apt-get upgrade -y -qq
  apt-get install -y -qq curl wget git ufw fail2ban unattended-upgrades gnupg btop make
  log_ok "Base packages installed"

  log_info "Enabling automatic security updates..."
  echo "unattended-upgrades unattended-upgrades/enable_auto_updates boolean true" | debconf-set-selections
  dpkg-reconfigure -f noninteractive unattended-upgrades
  log_ok "Automatic updates enabled"

  log_info "Configuring firewall..."
  ufw allow 22/tcp
  ufw allow 25565/tcp
  ufw allow 19132/udp
  ufw --force enable
  log_ok "UFW configured and enabled"
}

# -----------------------------------------------------------------------------
# Step 2 — Docker
# -----------------------------------------------------------------------------

step_docker() {
  log_section "Step 2 — Docker"

  if command -v docker &>/dev/null; then
    log_warn "Docker already installed, skipping"
    return
  fi

  log_info "Installing Docker..."
  curl -fsSL https://get.docker.com | sh
  usermod -aG docker "$ADMIN_USER"
  log_ok "Docker installed. User $ADMIN_USER added to docker group."
  log_warn "A reboot is needed for the docker group to take effect."
}

# -----------------------------------------------------------------------------
# Step 3 — Portainer
# -----------------------------------------------------------------------------

step_portainer() {
  log_section "Step 3 — Portainer"

  if docker ps -a --format '{{.Names}}' | grep -q "^portainer$"; then
    log_warn "Portainer already running, skipping"
    return
  fi

  log_info "Creating Portainer volume..."
  docker volume create portainer_data

  log_info "Starting Portainer..."
  docker run -d \
    --name portainer \
    --restart=always \
    -p 9443:9443 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data \
    portainer/portainer-ce:latest

  sleep 5
  TOKEN=$(docker logs portainer 2>&1 | grep setup_token | awk '{print $NF}')
  log_ok "Portainer running at https://$SERVER_IP:9443"
  if [ -n "$TOKEN" ]; then
    log_info "Setup token: $TOKEN"
  fi
}

# -----------------------------------------------------------------------------
# Step 4 — Crafty Controller
# -----------------------------------------------------------------------------

step_crafty() {
  log_section "Step 4 — Crafty Controller"

  if docker ps -a --format '{{.Names}}' | grep -q "^crafty$"; then
    log_warn "Crafty already running, skipping"
    return
  fi

  log_info "Creating Crafty directories..."
  mkdir -p /srv/minecraft/crafty
  chown -R root:root /srv/minecraft/crafty
  chmod -R 775 /srv/minecraft/crafty

  log_info "Writing compose.yml..."
  cat > /srv/minecraft/crafty/compose.yml << COMPOSE
services:
  crafty:
    image: registry.gitlab.com/crafty-controller/crafty-4:latest
    container_name: crafty
    restart: always
    environment:
      - TZ=$TIMEZONE
    ports:
      - "8000:8000"
      - "8443:8443"
      - "8123:8123"
      - "19132:19132/udp"
      - "25565:25565"
    volumes:
      - /srv/minecraft/crafty/backups:/crafty/backups
      - /srv/minecraft/crafty/logs:/crafty/logs
      - /srv/minecraft/crafty/servers:/crafty/servers
      - /srv/minecraft/crafty/config:/crafty/conf
      - /srv/minecraft/crafty/import:/crafty/import
COMPOSE

  log_info "Starting Crafty..."
  cd /srv/minecraft/crafty
  docker compose up -d
  cd - > /dev/null

  sleep 10
  CREDS=$(docker exec crafty cat /crafty/app/config/default-creds.txt 2>/dev/null || echo "Check logs: docker exec crafty cat /crafty/app/config/default-creds.txt")
  log_ok "Crafty running at https://$SERVER_IP:8443"
  log_info "Default credentials: $CREDS"
}

# -----------------------------------------------------------------------------
# Step 5 — Tailscale
# -----------------------------------------------------------------------------

step_tailscale() {
  log_section "Step 5 — Tailscale"

  if command -v tailscale &>/dev/null; then
    log_warn "Tailscale already installed, skipping"
  else
    log_info "Installing Tailscale..."
    curl -fsSL https://tailscale.com/install.sh | sh
    log_ok "Tailscale installed"
  fi

  systemctl enable tailscaled
  log_ok "Tailscale enabled on boot"
  log_warn "Manual step required: sudo tailscale up"
}

# -----------------------------------------------------------------------------
# Step 6 — Playit.gg
# -----------------------------------------------------------------------------

step_playit() {
  log_section "Step 6 — Playit.gg"

  if command -v playit &>/dev/null; then
    log_warn "Playit already installed, skipping"
  else
    log_info "Installing Playit.gg..."
    apt-get install -y gnupg
    curl -SsL https://packages.playit.gg/keys/playit.gpg | gpg --dearmor | tee /usr/share/keyrings/playit.gpg >/dev/null
    chmod 0644 /usr/share/keyrings/playit.gpg
    curl -fsSL -o /etc/apt/sources.list.d/playit.list https://packages.playit.gg/repo-files/playit-debian.list
    apt-get update -qq
    apt-get install -y playit
    log_ok "Playit.gg installed"
  fi

  systemctl enable playit
  log_ok "Playit enabled on boot"
  log_warn "Manual step required: sudo playit  (then open the claim link)"
}

# -----------------------------------------------------------------------------
# Summary
# -----------------------------------------------------------------------------

summary() {
  log_section "Installation Complete"

  echo -e "${GREEN}"
  echo "  Services installed:"
  echo "    Docker       — docker ps"
  echo "    Portainer    — https://$SERVER_IP:9443"
  echo "    Crafty       — https://$SERVER_IP:8443"
  echo "    Tailscale    — tailscale ip -4"
  echo "    Playit.gg    — systemctl status playit"
  echo ""
  echo "  Manual steps remaining:"
  echo "    1. Log out and back in (docker group)"
  echo "    2. sudo tailscale up"
  echo "    3. sudo playit"
  echo "    4. Create Minecraft server in Crafty"
  echo "    5. Create tunnels in playit.gg dashboard"
  echo ""
  echo "  Optional:"
  echo "    - Install Cloudflare Tunnel: bash scripts/07-cloudflare-tunnel.sh"
  echo -e "${NC}"
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

main() {
  echo ""
  echo -e "${CYAN}  ============================================${NC}"
  echo -e "${CYAN}   Minecraft Server — Full Install${NC}"
  echo -e "${CYAN}  ============================================${NC}"
  echo ""

  check_root
  check_env
  check_debian

  step_debian
  step_docker
  step_portainer
  step_crafty
  step_tailscale
  step_playit

  summary
}

main
