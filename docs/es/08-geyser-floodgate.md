# 08 — GeyserMC + Floodgate (Crossplay Java + Bedrock)

GeyserMC permite que jugadores de Bedrock entren a un servidor Java. Floodgate les permite hacerlo sin cuenta Java.

## Descarga

- GeyserMC: https://geysermc.org/download (seleccionar Spigot/Paper)
- Floodgate: misma página, seleccionar Spigot

## Instalación

1. Coloca ambos archivos `.jar` en la carpeta `plugins` del servidor (via Crafty > Files)
2. Reinicia el servidor
3. Los archivos de configuración de Geyser y Floodgate se generan automáticamente

## Configuración de Geyser

Archivo: `plugins/Geyser-Spigot/config.yml`

Configuración clave:

```yaml
bedrock:
  port: 19132
  clone-remote-port: false

remote:
  address: 127.0.0.1
  port: 25565
  auth-type: floodgate
```

## Configuración de Floodgate

Archivo: `plugins/floodgate/config.yml`

```yaml
# No se necesitan cambios para la configuración básica
```

## Túnel Bedrock en Playit.gg

Crea un segundo túnel en Playit.gg:
- Tipo: Minecraft Bedrock
- Puerto local: 19132
- Protocolo: UDP

## Conexión para jugadores Bedrock

Los jugadores Bedrock se conectan con:
- Dirección del servidor: `YOUR_BEDROCK_TUNNEL.tun.ply.gg` o `bedrock.YOUR_DOMAIN`
- Puerto: `19132`

## Notas

- Con Floodgate, los jugadores Bedrock tienen un prefijo `*` en su nombre de usuario (ej. `*.NombreJugador`)
- Los jugadores Java no se ven afectados
- `online-mode` debe ser `false` en `server.properties` para que Floodgate funcione
