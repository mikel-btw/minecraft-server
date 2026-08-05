# 09 — Cloudflare Tunnel

Cloudflare Tunnel exposes local services to the internet over HTTPS without port forwarding or opening router ports. The tunnel initiates an outbound connection from your server to Cloudflare's network.

## Requirements

- A domain added to Cloudflare (any supported TLD)
- Cloudflare account (free tier)
- `cloudflared` installed on the server

---

## Installation

```bash
curl -L https://pkg.cloudflare.com/cloudflare-main.gpg | sudo tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared any main" | sudo tee /etc/apt/sources.list.d/cloudflared.list
sudo apt update
sudo apt install cloudflared -y
```

---

## Authenticate with Cloudflare

```bash
cloudflared tunnel login
```

Opens a browser link. Select your domain and authorize.

---

## Create the tunnel

```bash
cloudflared tunnel create YOUR_TUNNEL_NAME
```

This generates a credentials file at `~/.cloudflared/TUNNEL_ID.json`. Keep this file secret.

---

## Configuration file

Create `~/.cloudflared/config.yml`:

```yaml
tunnel: YOUR_TUNNEL_ID
credentials-file: /home/YOUR_USER/.cloudflared/YOUR_TUNNEL_ID.json

ingress:
  - hostname: YOUR_SUBDOMAIN.YOUR_DOMAIN
    service: https://localhost:YOUR_LOCAL_PORT
    originRequest:
      noTLSVerify: true
  - service: http_status:404
```

- `noTLSVerify: true` is needed if the local service uses a self-signed certificate.
- The last `http_status:404` entry is required as a catch-all.

---

## Create DNS record

```bash
cloudflared tunnel route dns YOUR_TUNNEL_NAME YOUR_SUBDOMAIN.YOUR_DOMAIN
```

This automatically creates a CNAME record in Cloudflare DNS pointing to the tunnel.

---

## Install as a system service

```bash
sudo cloudflared --config /home/YOUR_USER/.cloudflared/config.yml service install
sudo systemctl enable cloudflared
sudo systemctl start cloudflared
```

---

## Verification

```bash
sudo systemctl status cloudflared
```

Access your service at `https://YOUR_SUBDOMAIN.YOUR_DOMAIN`.

---

## Notes

- Cloudflare Tunnel only works for HTTP/HTTPS services. It cannot tunnel raw TCP/UDP game traffic.
- For Minecraft player connections, use Playit.gg (see `06-playit.md`).
- Cloudflare issues a free SSL certificate automatically.
