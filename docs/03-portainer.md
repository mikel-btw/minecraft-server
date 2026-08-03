# 03 — Portainer

## Installation

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

## Setup token

Portainer CE requires a setup token on first run. Get it from the logs:

```bash
docker logs portainer 2>&1 | grep setup_token
```

You have 5 minutes from container start. If expired:

```bash
docker restart portainer
docker logs portainer 2>&1 | grep setup_token
```

## Access

```
https://SERVER_IP:9443
https://TAILSCALE_IP:9443  (remote)
```

Accept the self-signed certificate warning.
