# 08 — GeyserMC + Floodgate (Crossplay Java + Bedrock)

GeyserMC allows Bedrock players to join a Java server. Floodgate allows them to do so without a Java account.

## Download

- GeyserMC: https://geysermc.org/download (select Spigot/Paper)
- Floodgate: same page, select Spigot

## Installation

1. Place both `.jar` files in the `plugins` folder of your server (via Crafty > Files)
2. Restart the server
3. Geyser and Floodgate config files are generated automatically

## Geyser configuration

File: `plugins/Geyser-Spigot/config.yml`

Key settings:

```yaml
bedrock:
  port: 19132
  clone-remote-port: false

remote:
  address: 127.0.0.1
  port: 25565
  auth-type: floodgate
```

## Floodgate configuration

File: `plugins/floodgate/config.yml`

```yaml
# No changes needed for basic setup
```

## Playit.gg Bedrock tunnel

Create a second tunnel in Playit.gg:
- Type: Minecraft Bedrock
- Local port: 19132
- Protocol: UDP

## Bedrock player connection

Bedrock players connect using:
- Server address: `YOUR_BEDROCK_TUNNEL.tun.ply.gg` or `bedrock.YOUR_DOMAIN`
- Port: `19132`

## Notes

- With Floodgate, Bedrock players get a `*` prefix on their username (e.g. `*.PlayerName`)
- Java players are unaffected
- `online-mode` must be `false` in `server.properties` for Floodgate to work
