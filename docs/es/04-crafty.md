# 04 — Crafty Controller

## Estructura de directorios

```bash
sudo mkdir -p /srv/minecraft/crafty
sudo chown -R root:root /srv/minecraft/crafty
sudo chmod -R 775 /srv/minecraft/crafty
```

## compose.yml

Ubicación: `/srv/minecraft/crafty/compose.yml`

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

## Iniciar

```bash
cd /srv/minecraft/crafty
docker compose up -d
```

## Credenciales iniciales

```bash
docker exec crafty cat /crafty/app/config/default-creds.txt
```

## Acceso

```
https://SERVER_IP:8443
https://TAILSCALE_IP:8443  (remoto)
```

## Crear el servidor de Minecraft en Crafty

- Tipo: Minecraft Java
- Software: Paper
- Versión: última estable (1.21.x)
- RAM mínima: 1GB
- RAM máxima: 5GB (ajustar según hardware)
- Puerto: 25565

## online-mode (para cuentas no premium)

En Crafty > servidor > Files > `server.properties`:

```
online-mode=false
```

Reiniciar el servidor después de cambiar.

> **Advertencia:** Con `online-mode=false` cualquier persona puede entrar con cualquier nombre.  
> Instala el plugin **AuthMe** para proteger las cuentas con contraseña.
