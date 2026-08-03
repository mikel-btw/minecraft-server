#!/bin/bash
set -e

echo "==> Installing Tailscale..."
curl -fsSL https://tailscale.com/install.sh | sh

echo "==> Enabling Tailscale on boot..."
systemctl enable tailscaled

echo ""
echo "✓ Tailscale installed."
echo "  Run: sudo tailscale up"
echo "  Then open the link shown to authenticate."
