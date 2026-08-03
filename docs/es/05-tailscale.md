# 05 — Tailscale (Acceso Remoto Privado)

Tailscale crea una VPN privada entre tus dispositivos. Se usa para SSH y acceso a paneles de administración desde cualquier lugar sin exponer puertos públicamente.

## Instalación en el servidor

```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up
```

Abre el enlace que aparece en la terminal, inicia sesión con tu cuenta (GitHub/Google) y autoriza el dispositivo.

## Habilitar al inicio

```bash
sudo systemctl enable tailscaled
sudo systemctl is-enabled tailscaled  # debe responder: enabled
```

## Ver IP de Tailscale

```bash
tailscale ip -4
```

## Instalar en otros dispositivos

Descarga desde https://tailscale.com/download e inicia sesión con la misma cuenta. Todos los dispositivos en el mismo tailnet pueden comunicarse directamente.

## SSH desde cualquier lugar

```bash
ssh YOUR_USER@TAILSCALE_IP
```

## Notas

- Tailscale gestiona su propio DNS via `/etc/resolv.conf`. No editar ese archivo manualmente.
- El servidor necesita acceso a internet saliente para que Tailscale conecte (inicia conexión saliente, no necesita port forwarding).
