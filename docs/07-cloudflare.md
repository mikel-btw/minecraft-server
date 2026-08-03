# 07 — Cloudflare DNS (Pending)

## Requirements

- A domain you control
- Ability to change nameservers at your registrar
- A Cloudflare account (free tier is enough)

## Steps

1. Add your domain to Cloudflare at https://dash.cloudflare.com
2. Change your domain's nameservers to the ones Cloudflare provides
3. Wait for propagation (usually 5-30 minutes)

## DNS Records

### Java (CNAME to Playit tunnel)

| Type | Name | Value | Proxy |
|---|---|---|---|
| CNAME | @ or play | YOUR_TUNNEL.tun.ply.gg | Off (grey cloud) |

### Bedrock (CNAME to Playit tunnel)

| Type | Name | Value | Proxy |
|---|---|---|---|
| CNAME | bedrock | YOUR_BEDROCK_TUNNEL.tun.ply.gg | Off (grey cloud) |

> **Important:** Proxy must be OFF (grey cloud) for Minecraft. Cloudflare proxying does not support TCP/UDP game traffic on the free plan.

## Result

Players connect with:
```
YOUR_DOMAIN        (Java, port 25565)
bedrock.YOUR_DOMAIN (Bedrock, port 19132)
```
