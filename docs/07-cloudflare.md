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

---

## DNS records for Minecraft (via Playit.gg)

### Java

| Type | Name | Target | Proxy |
|---|---|---|---|
| CNAME | java | YOUR_JAVA_TUNNEL.tun.ply.gg | Off (grey cloud) |

### Bedrock

Since Playit assigns a non-standard port for Bedrock, use a direct A record:

| Type | Name | Content | Proxy |
|---|---|---|---|
| A | bedrock | PLAYIT_BEDROCK_IP | Off (grey cloud) |

Players connect with:
- Java: `java.YOUR_DOMAIN` (port 25565)
- Bedrock: `bedrock.YOUR_DOMAIN` port `PLAYIT_BEDROCK_PORT` (entered separately in the Bedrock client)

> **Note:** Cloudflare cannot proxy Minecraft TCP/UDP traffic. Proxy must always be OFF for these records.
