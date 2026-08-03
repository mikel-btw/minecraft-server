# 03 — Portainer

## Instalación

```bash
docker volume create portainer_data

docker run -d \
  --name portainer \
  --restart=always \
  -p 9443:9443 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:latest
```

## Token de setup

Portainer CE requiere un token de setup en el primer arranque. Obtenerlo de los logs:

```bash
docker logs portainer 2>&1 | grep setup_token
```

Tienes 5 minutos desde que arranca el contenedor. Si expiró:

```bash
docker restart portainer
docker logs portainer 2>&1 | grep setup_token
```

## Acceso

```
https://SERVER_IP:9443
https://TAILSCALE_IP:9443  (remoto)
```

Acepta la advertencia del certificado autofirmado.
