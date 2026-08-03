# 06 — Playit.gg (Túnel Público para Jugadores)

Playit.gg crea túneles públicos para Minecraft (Java TCP + Bedrock UDP) sin port forwarding ni acceso al router.

## Instalación

```bash
sudo apt install gnupg -y

curl -SsL https://packages.playit.gg/keys/playit.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/playit.gpg >/dev/null
sudo chmod 0644 /usr/share/keyrings/playit.gpg
sudo curl -fsSL -o /etc/apt/sources.list.d/playit.list https://packages.playit.gg/repo-files/playit-debian.list
sudo apt update
sudo apt install playit
```

## Vincular a tu cuenta

```bash
sudo playit
```

Abre el enlace de claim que aparece en la terminal e inicia sesión en playit.gg.

## Habilitar al inicio

```bash
sudo systemctl enable playit
sudo systemctl start playit
```

## Crear túneles (en el dashboard de playit.gg)

### Túnel Java
- Tipo: Minecraft Java
- IP local: 127.0.0.1
- Puerto local: 25565

### Túnel Bedrock
- Tipo: Minecraft Bedrock
- IP local: 127.0.0.1
- Puerto local: 19132

## Dirección de conexión para jugadores

Playit asigna una dirección pública como:

```
something.tun.ply.gg
```

Los jugadores se conectan a esa dirección en Minecraft. No se necesita puerto para el túnel Java por defecto.

## Verificar estado

```bash
sudo systemctl status playit
sudo journalctl -u playit --no-pager
```
