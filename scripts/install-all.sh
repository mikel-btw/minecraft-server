#!/bin/bash
set -e

SCRIPT_DIR="$(dirname "$0")"

echo "======================================"
echo " Minecraft Server — Full Setup"
echo "======================================"
echo ""

if [ ! -f "$SCRIPT_DIR/../.env" ]; then
  echo "ERROR: .env file not found."
  echo "Copy .env.example to .env and fill in your values first."
  exit 1
fi

echo "Running all setup scripts in order..."
echo ""

bash "$SCRIPT_DIR/01-debian-base.sh"
echo ""
bash "$SCRIPT_DIR/02-docker.sh"
echo ""
bash "$SCRIPT_DIR/03-portainer.sh"
echo ""
bash "$SCRIPT_DIR/04-crafty.sh"
echo ""
bash "$SCRIPT_DIR/05-tailscale.sh"
echo ""
bash "$SCRIPT_DIR/06-playit.sh"

echo ""
echo "======================================"
echo " All steps complete."
echo " Manual steps remaining:"
echo "  1. sudo tailscale up  (authenticate Tailscale)"
echo "  2. sudo playit        (link Playit.gg agent)"
echo "  3. Configure Cloudflare DNS (see docs/07-cloudflare.md)"
echo "  4. Install GeyserMC + Floodgate in Crafty (see docs/08-geyser-floodgate.md)"
echo "======================================"
