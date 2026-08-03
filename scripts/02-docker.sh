#!/bin/bash
set -e

if [ -f "$(dirname "$0")/../.env" ]; then
  source "$(dirname "$0")/../.env"
else
  echo "ERROR: .env file not found."
  exit 1
fi

echo "==> Installing Docker..."
curl -fsSL https://get.docker.com | sh
usermod -aG docker "$ADMIN_USER"

echo ""
echo "✓ Docker installed."
echo "  Log out and back in (or reboot) for the docker group to take effect."
