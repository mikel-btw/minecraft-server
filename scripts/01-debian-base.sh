#!/bin/bash
set -e

# Load variables
if [ -f "$(dirname "$0")/../.env" ]; then
  source "$(dirname "$0")/../.env"
else
  echo "ERROR: .env file not found. Copy .env.example to .env and fill in your values."
  exit 1
fi

echo "==> [1/7] Installing sudo..."
apt install -y sudo
usermod -aG sudo "$ADMIN_USER"

echo "==> [2/7] Configuring static IP via dhcpcd..."
cat >> /etc/dhcpcd.conf << DHCP

interface $WIFI_INTERFACE
static ip_address=$SERVER_IP/24
static routers=$GATEWAY_IP
static domain_name_servers=8.8.8.8 1.1.1.1
DHCP

echo "==> [3/7] Configuring /etc/network/interfaces..."
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

echo "==> [4/7] Disabling laptop sleep/suspend..."
systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

echo "==> [5/7] Installing base packages..."
apt update && apt upgrade -y
apt install -y curl wget git ufw fail2ban unattended-upgrades gnupg btop

echo "==> [6/7] Enabling automatic security updates..."
echo "unattended-upgrades unattended-upgrades/enable_auto_updates boolean true" | debconf-set-selections
dpkg-reconfigure -f noninteractive unattended-upgrades

echo "==> [7/7] Configuring firewall..."
ufw allow ssh
ufw --force enable

echo ""
echo "✓ Debian base setup complete."
echo "  Please log out and back in for sudo group changes to take effect."
