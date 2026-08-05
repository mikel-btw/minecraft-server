#!/bin/bash
set -e

if [ -f "$(dirname "$0")/../.env" ]; then
  source "$(dirname "$0")/../.env"
else
  echo "ERROR: .env file not found."
  exit 1
fi

echo "==> [1/4] Installing cloudflared..."
curl -L https://pkg.cloudflare.com/cloudflare-main.gpg | tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared any main" | tee /etc/apt/sources.list.d/cloudflared.list
apt update
apt install cloudflared -y

echo ""
echo "==> [2/4] Authenticate with Cloudflare..."
echo "  Run: cloudflared tunnel login"
echo "  Then open the link shown and authorize your domain."
echo ""
read -p "Press Enter after authenticating..."

echo "==> [3/4] Creating tunnel..."
cloudflared tunnel create "$TUNNEL_NAME"
TUNNEL_ID=$(cloudflared tunnel list | grep "$TUNNEL_NAME" | awk '{print $1}')

echo "==> [4/4] Writing config and creating DNS record..."
cat > /home/"$ADMIN_USER"/.cloudflared/config.yml << CONFIG
tunnel: $TUNNEL_ID
credentials-file: /home/$ADMIN_USER/.cloudflared/$TUNNEL_ID.json

ingress:
  - hostname: $TUNNEL_SUBDOMAIN.$YOUR_DOMAIN
    service: https://localhost:$TUNNEL_LOCAL_PORT
    originRequest:
      noTLSVerify: true
  - service: http_status:404
CONFIG

cloudflared tunnel route dns "$TUNNEL_NAME" "$TUNNEL_SUBDOMAIN.$YOUR_DOMAIN"

cloudflared --config /home/"$ADMIN_USER"/.cloudflared/config.yml service install
systemctl enable cloudflared
systemctl start cloudflared

echo ""
echo "✓ Cloudflare Tunnel running."
echo "  Access your service at: https://$TUNNEL_SUBDOMAIN.$YOUR_DOMAIN"
