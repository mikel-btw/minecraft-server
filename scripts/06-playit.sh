#!/bin/bash
set -e

echo "==> Installing Playit.gg..."
apt install -y gnupg

curl -SsL https://packages.playit.gg/keys/playit.gpg | gpg --dearmor | tee /usr/share/keyrings/playit.gpg >/dev/null
chmod 0644 /usr/share/keyrings/playit.gpg
curl -fsSL -o /etc/apt/sources.list.d/playit.list https://packages.playit.gg/repo-files/playit-debian.list
apt update
apt install -y playit

systemctl enable playit

echo ""
echo "✓ Playit.gg installed."
echo "  Run: sudo playit"
echo "  Then open the claim link to link this agent to your playit.gg account."
echo "  After linking, create your tunnels at https://playit.gg"
