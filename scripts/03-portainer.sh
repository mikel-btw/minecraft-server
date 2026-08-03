#!/bin/bash
set -e

echo "==> Creating Portainer volume..."
docker volume create portainer_data

echo "==> Starting Portainer..."
docker run -d \
  --name portainer \
  --restart=always \
  -p 9443:9443 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:latest

echo ""
echo "✓ Portainer running."
echo "  Setup token:"
sleep 5
docker logs portainer 2>&1 | grep setup_token || echo "  (token not found yet, run: docker logs portainer 2>&1 | grep setup_token)"
echo "  Access: https://SERVER_IP:9443"
