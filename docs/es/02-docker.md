# 02 — Docker

## Instalación

```bash
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker YOUR_USER
```

Reiniciar o cerrar sesión y volver a entrar para que el grupo tome efecto.

## Verificación

```bash
docker ps
docker run hello-world
```

## Notas

- Docker se configura para iniciar automáticamente al arrancar el sistema.
- No usar modo rootless; Crafty y Portainer requieren el socket estándar de Docker.
