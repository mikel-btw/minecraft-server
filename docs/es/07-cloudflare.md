# 07 — Cloudflare DNS (Pendiente)

## Requisitos

- Un dominio propio
- Capacidad de cambiar nameservers en tu registrador
- Cuenta en Cloudflare (el plan gratuito es suficiente)

## Pasos

1. Agrega tu dominio en Cloudflare en https://dash.cloudflare.com
2. Cambia los nameservers de tu dominio a los que Cloudflare te proporciona
3. Espera la propagación (normalmente 5-30 minutos)

## Registros DNS

### Java (CNAME al túnel de Playit)

| Tipo | Nombre | Valor | Proxy |
|---|---|---|---|
| CNAME | @ o play | YOUR_TUNNEL.tun.ply.gg | Apagado (nube gris) |

### Bedrock (CNAME al túnel de Playit)

| Tipo | Nombre | Valor | Proxy |
|---|---|---|---|
| CNAME | bedrock | YOUR_BEDROCK_TUNNEL.tun.ply.gg | Apagado (nube gris) |

> **Importante:** El proxy debe estar APAGADO (nube gris) para Minecraft. El proxy de Cloudflare no soporta tráfico TCP/UDP de juegos en el plan gratuito.

## Resultado

Los jugadores se conectan con:
```
YOUR_DOMAIN              (Java, puerto 25565)
bedrock.YOUR_DOMAIN      (Bedrock, puerto 19132)
```
