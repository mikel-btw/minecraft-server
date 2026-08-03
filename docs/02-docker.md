# 02 — Docker

## Installation

```bash
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker YOUR_USER
```

Reboot or log out and back in for group changes to take effect.

## Verification

```bash
docker ps
docker run hello-world
```

## Notes

- Docker is configured to start automatically on boot by the install script.
- Do not use rootless mode; Crafty and Portainer require the standard Docker socket.
