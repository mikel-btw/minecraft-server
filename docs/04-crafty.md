# 04 — Crafty Controller

## Directory structure

```bash
sudo mkdir -p /srv/minecraft/crafty
sudo chown -R root:root /srv/minecraft/crafty
sudo chmod -R 775 /srv/minecraft/crafty
```

## compose.yml

Location: `/srv/minecraft/crafty/compose.yml`

```yaml
services:
  crafty:
    image: registry.gitlab.com/crafty-controller/crafty-4:latest
    container_name: crafty
    restart: always
    environment:
      - TZ=YOUR_TIMEZONE
    ports:
      - "8000:8000"
      - "8443:8443"
      - "8123:8123"
      - "19132:19132/udp"
      - "25565:25565"
    volumes:
      - /srv/minecraft/crafty/backups:/crafty/backups
      - /srv/minecraft/crafty/logs:/crafty/logs
      - /srv/minecraft/crafty/servers:/crafty/servers
      - /srv/minecraft/crafty/config:/crafty/conf
      - /srv/minecraft/crafty/import:/crafty/import
```

## Start

```bash
cd /srv/minecraft/crafty
docker compose up -d
```

## Default credentials

```bash
docker exec crafty cat /crafty/app/config/default-creds.txt
```

## Access

```
https://SERVER_IP:8443
https://TAILSCALE_IP:8443  (remote)
```

## Creating the Minecraft server inside Crafty

- Type: Minecraft Java
- Software: Paper
- Version: latest stable (1.21.x)
- Min RAM: 1GB
- Max RAM: 5GB (adjust based on your hardware)
- Port: 25565

## online-mode (for non-premium accounts)

In Crafty > server > Files > `server.properties`:

```
online-mode=false
```

Restart the server after changing.

> **Warning:** With `online-mode=false` anyone can join with any username.  
> Install the **AuthMe** plugin to protect accounts with passwords.
