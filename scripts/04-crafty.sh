#!/bin/bash
set -e

if [ -f "$(dirname "$0")/../.env" ]; then
  source "$(dirname "$0")/../.env"
else
  echo "ERROR: .env file not found."
  exit 1
fi

echo "==> Creating Crafty directories..."
mkdir -p /srv/minecraft/crafty
chown -R root:root /srv/minecraft/crafty
chmod -R 775 /srv/minecraft/crafty

echo "==> Writing compose.yml..."
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

echo "==> Starting Crafty..."
cd /srv/minecraft/crafty
docker compose up -d

echo ""
echo "✓ Crafty Controller running."
echo "  Default credentials:"
sleep 10
docker exec crafty cat /crafty/app/config/default-creds.txt 2>/dev/null || echo "  (not ready yet, run: docker exec crafty cat /crafty/app/config/default-creds.txt)"
echo "  Access: https://SERVER_IP:8443"
