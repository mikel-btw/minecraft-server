# Minecraft Server — Self-Hosted Setup

> **Language / Idioma**: [English](#english) | [Español](#español)

---

<a name="english"></a>
# 🇬🇧 English

## What is this?

A complete, reproducible guide and set of scripts to deploy a self-hosted Minecraft server on a Debian Linux machine — without touching your router, without port forwarding, and without a static public IP.

Built around Docker, Crafty Controller, Tailscale, and Playit.gg.

---

## Stack

| Component | Purpose |
|---|---|
| Debian 12+ (CLI) | Base OS |
| Docker | Container runtime |
| Portainer | Docker web UI |
| Crafty Controller | Minecraft server panel |
| Paper (Minecraft Java) | Game server |
| GeyserMC + Floodgate | Java + Bedrock crossplay |
| Tailscale | Private remote access (SSH, admin panels) |
| Playit.gg | Public tunnel for players (no port forwarding needed) |
| Cloudflare | DNS for your domain |

---

## Recommended Hardware

| Players | CPU | RAM | Storage | Network |
|---|---|---|---|---|
| 1-10 | 4 cores / 2.0GHz+ | 8GB | 500GB HDD | 10 Mbps upload |
| 10-30 | 6 cores / 3.0GHz+ | 16GB | 500GB SSD | 30 Mbps upload |
| 30-60 | 8 cores / 3.5GHz+ | 32GB | 1TB NVMe | 100 Mbps upload |
| 60-100 | 12 cores / 4.0GHz+ | 64GB | 2TB NVMe | 500 Mbps upload |

> **Note:** HDD works but causes slow chunk loading. SSD or NVMe is strongly recommended for 10+ players.  
> WiFi works but Ethernet is always more stable for a server.

---

## RAM Allocation Guide

### Java only (Paper/Vanilla)

| Players | Recommended RAM for Minecraft | Notes |
|---|---|---|
| 1-10 | 4-5 GB | Comfortable with plugins |
| 10-30 | 8-10 GB | Required for modpacks |
| 30-60 | 12-16 GB | Heavy plugin load |
| 60-100 | 20-24 GB | Dedicated machine recommended |

### Crossplay: Java + Bedrock (GeyserMC)

Add ~512MB to the Java allocation for GeyserMC overhead. Bedrock players go through GeyserMC, so they do not need a separate server process.

| Players (mixed) | Recommended RAM for Minecraft |
|---|---|
| 1-10 | 5 GB |
| 10-30 | 10 GB |
| 30-60 | 16 GB |
| 60-100 | 24 GB |

### Full system RAM budget

| Component | Estimated Usage |
|---|---|
| Debian OS | ~500 MB |
| Docker daemon | ~200 MB |
| Portainer | ~150 MB |
| Crafty Controller | ~300 MB |
| Minecraft (see above) | variable |
| **Buffer** | 1-2 GB |

---

## Repo Structure

```
minecraft-server/
├── .env.example          # Variable template — copy to .env and fill in
├── .env                  # Your real values — never committed (in .gitignore)
├── .gitignore
├── README.md
├── docs/
│   ├── 01-debian.md         # Base OS setup
│   ├── 02-docker.md         # Docker installation
│   ├── 03-portainer.md      # Portainer setup
│   ├── 04-crafty.md         # Crafty Controller
│   ├── 05-tailscale.md      # Tailscale VPN
│   ├── 06-playit.md         # Playit.gg tunnel
│   ├── 07-cloudflare.md     # Cloudflare DNS
│   └── 08-geyser-floodgate.md  # Crossplay setup
└── scripts/
    ├── 01-debian-base.sh
    ├── 02-docker.sh
    ├── 03-portainer.sh
    ├── 04-crafty.sh
    ├── 05-tailscale.sh
    ├── 06-playit.sh
    └── install-all.sh       # Runs all scripts in order
```

---

## Documentation

| Step | Doc |
|---|---|
| 01 — Debian base | [docs/01-debian.md](docs/01-debian.md) |
| 02 — Docker | [docs/02-docker.md](docs/02-docker.md) |
| 03 — Portainer | [docs/03-portainer.md](docs/03-portainer.md) |
| 04 — Crafty Controller | [docs/04-crafty.md](docs/04-crafty.md) |
| 05 — Tailscale | [docs/05-tailscale.md](docs/05-tailscale.md) |
| 06 — Playit.gg | [docs/06-playit.md](docs/06-playit.md) |
| 07 — Cloudflare | [docs/07-cloudflare.md](docs/07-cloudflare.md) |
| 08 — GeyserMC + Floodgate | [docs/08-geyser-floodgate.md](docs/08-geyser-floodgate.md) |

---

## Quick Start

```bash
# 1. Clone the repo on your server
git clone https://github.com/YOUR_USER/minecraft-server.git
cd minecraft-server

# 2. Copy and fill in your variables
cp .env.example .env
nano .env

# 3. Run all setup scripts in order
chmod +x scripts/*.sh
bash scripts/install-all.sh

# Or run them one by one:
bash scripts/01-debian-base.sh
bash scripts/02-docker.sh
# etc.
```

---

## Access After Setup

| Service | URL |
|---|---|
| Crafty Controller | `https://SERVER_IP:8443` |
| Portainer | `https://SERVER_IP:9443` |
| Minecraft Java | `SERVER_IP:25565` |
| Minecraft Bedrock | `SERVER_IP:19132` |
| Remote (Tailscale) | `https://TAILSCALE_IP:8443` |
| Public (players) | `YOUR_TUNNEL.tun.ply.gg` or `YOUR_DOMAIN` |

---

## Status

| Step | Status |
|---|---|
| Debian base setup | Done |
| Docker | Done |
| Portainer | Done |
| Crafty Controller | Done |
| Minecraft Java server | Done |
| Tailscale | Done |
| Playit.gg tunnel (Java) | Done |
| Playit.gg tunnel (Bedrock) | Pending |
| GeyserMC + Floodgate | Pending |
| Cloudflare DNS | Pending |
| AuthMe plugin | Pending |

---

---

<a name="español"></a>
# 🇪🇸 Español

## ¿Qué es esto?

Una guía completa y reproducible con scripts para desplegar un servidor de Minecraft propio en una máquina con Debian Linux — sin tocar el router, sin port forwarding y sin IP pública estática.

Construido con Docker, Crafty Controller, Tailscale y Playit.gg.

---

## Stack

| Componente | Función |
|---|---|
| Debian 12+ (CLI) | Sistema operativo base |
| Docker | Contenedores |
| Portainer | Panel visual de Docker |
| Crafty Controller | Panel de gestión de Minecraft |
| Paper (Minecraft Java) | Servidor del juego |
| GeyserMC + Floodgate | Crossplay Java + Bedrock |
| Tailscale | Acceso remoto privado (SSH, paneles de admin) |
| Playit.gg | Túnel público para jugadores (sin port forwarding) |
| Cloudflare | DNS del dominio |

---

## Hardware Recomendado

| Jugadores | CPU | RAM | Almacenamiento | Red (subida) |
|---|---|---|---|---|
| 1-10 | 4 núcleos / 2.0GHz+ | 8GB | 500GB HDD | 10 Mbps |
| 10-30 | 6 núcleos / 3.0GHz+ | 16GB | 500GB SSD | 30 Mbps |
| 30-60 | 8 núcleos / 3.5GHz+ | 32GB | 1TB NVMe | 100 Mbps |
| 60-100 | 12 núcleos / 4.0GHz+ | 64GB | 2TB NVMe | 500 Mbps |

> **Nota:** HDD funciona pero causa carga lenta de chunks. SSD o NVMe es muy recomendado para 10+ jugadores.  
> WiFi funciona pero Ethernet siempre es más estable para un servidor.

---

## Guía de RAM

### Solo Java (Paper/Vanilla)

| Jugadores | RAM recomendada para Minecraft | Notas |
|---|---|---|
| 1-10 | 4-5 GB | Cómodo con plugins |
| 10-30 | 8-10 GB | Necesario para modpacks |
| 30-60 | 12-16 GB | Carga pesada de plugins |
| 60-100 | 20-24 GB | Se recomienda máquina dedicada |

### Crossplay: Java + Bedrock (GeyserMC)

Agrega ~512MB a la asignación de Java para el overhead de GeyserMC. Los jugadores Bedrock pasan por GeyserMC, no necesitan un proceso de servidor separado.

| Jugadores (mixtos) | RAM recomendada para Minecraft |
|---|---|
| 1-10 | 5 GB |
| 10-30 | 10 GB |
| 30-60 | 16 GB |
| 60-100 | 24 GB |

### Presupuesto total de RAM del sistema

| Componente | Uso estimado |
|---|---|
| Debian OS | ~500 MB |
| Docker daemon | ~200 MB |
| Portainer | ~150 MB |
| Crafty Controller | ~300 MB |
| Minecraft (ver arriba) | variable |
| **Margen de seguridad** | 1-2 GB |

---

## Estructura del Repo

```
minecraft-server/
├── .env.example          # Plantilla de variables — copia a .env y completa
├── .env                  # Tus valores reales — nunca se sube (está en .gitignore)
├── .gitignore
├── README.md
├── docs/
│   ├── 01-debian.md         # Configuración base del OS
│   ├── 02-docker.md         # Instalación de Docker
│   ├── 03-portainer.md      # Configuración de Portainer
│   ├── 04-crafty.md         # Crafty Controller
│   ├── 05-tailscale.md      # VPN Tailscale
│   ├── 06-playit.md         # Túnel Playit.gg
│   ├── 07-cloudflare.md     # DNS Cloudflare
│   └── 08-geyser-floodgate.md  # Configuración crossplay
└── scripts/
    ├── 01-debian-base.sh
    ├── 02-docker.sh
    ├── 03-portainer.sh
    ├── 04-crafty.sh
    ├── 05-tailscale.sh
    ├── 06-playit.sh
    └── install-all.sh       # Ejecuta todos los scripts en orden
```

---

## Documentación

| Paso | Archivo |
|---|---|
| 01 — Debian base | [docs/es/01-debian.md](docs/es/01-debian.md) |
| 02 — Docker | [docs/es/02-docker.md](docs/es/02-docker.md) |
| 03 — Portainer | [docs/es/03-portainer.md](docs/es/03-portainer.md) |
| 04 — Crafty Controller | [docs/es/04-crafty.md](docs/es/04-crafty.md) |
| 05 — Tailscale | [docs/es/05-tailscale.md](docs/es/05-tailscale.md) |
| 06 — Playit.gg | [docs/es/06-playit.md](docs/es/06-playit.md) |
| 07 — Cloudflare | [docs/es/07-cloudflare.md](docs/es/07-cloudflare.md) |
| 08 — GeyserMC + Floodgate | [docs/es/08-geyser-floodgate.md](docs/es/08-geyser-floodgate.md) |

---

## Inicio Rápido

```bash
# 1. Clona el repo en tu servidor
git clone https://github.com/YOUR_USER/minecraft-server.git
cd minecraft-server

# 2. Copia y completa tus variables
cp .env.example .env
nano .env

# 3. Ejecuta todos los scripts en orden
chmod +x scripts/*.sh
bash scripts/install-all.sh

# O uno por uno:
bash scripts/01-debian-base.sh
bash scripts/02-docker.sh
# etc.
```

---

## Acceso Después del Setup

| Servicio | URL |
|---|---|
| Crafty Controller | `https://SERVER_IP:8443` |
| Portainer | `https://SERVER_IP:9443` |
| Minecraft Java | `SERVER_IP:25565` |
| Minecraft Bedrock | `SERVER_IP:19132` |
| Remoto (Tailscale) | `https://TAILSCALE_IP:8443` |
| Público (jugadores) | `YOUR_TUNNEL.tun.ply.gg` o `YOUR_DOMAIN` |

---

## Estado del Proyecto

| Paso | Estado |
|---|---|
| Configuración base Debian | Hecho |
| Docker | Hecho |
| Portainer | Hecho |
| Crafty Controller | Hecho |
| Servidor Minecraft Java | Hecho |
| Tailscale | Hecho |
| Túnel Playit.gg (Java) | Hecho |
| Túnel Playit.gg (Bedrock) | Pendiente |
| GeyserMC + Floodgate | Pendiente |
| DNS Cloudflare | Pendiente |
| Plugin AuthMe | Pendiente |
