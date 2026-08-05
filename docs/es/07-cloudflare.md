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

---

## Registros DNS para Minecraft (via Playit.gg)

### Java

| Tipo | Nombre | Destino | Proxy |
|---|---|---|---|
| CNAME | java | YOUR_JAVA_TUNNEL.tun.ply.gg | Apagado (nube gris) |

### Bedrock

Como Playit asigna un puerto no estandar para Bedrock, usa un registro A directo:

| Tipo | Nombre | Contenido | Proxy |
|---|---|---|---|
| A | bedrock | PLAYIT_BEDROCK_IP | Apagado (nube gris) |

Los jugadores se conectan con:
- Java: `java.YOUR_DOMAIN` (puerto 25565)
- Bedrock: `bedrock.YOUR_DOMAIN` puerto `PLAYIT_BEDROCK_PORT` (se ingresa separado en el cliente Bedrock)

> **Nota:** Cloudflare no puede proxear trafico TCP/UDP de Minecraft. El proxy debe estar siempre APAGADO para estos registros.
