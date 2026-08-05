# Minecraft Server — Self-Hosted Setup

> **Language / Idioma**: [English](#english) | [Español](#español)

---

<a name="english"></a>
# 🇬🇧 English

## What is this?

A complete, reproducible guide and automation toolkit to deploy a self-hosted Minecraft server on a Debian Linux machine — without touching your router, without port forwarding, and without a static public IP.

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
| Cloudflare Tunnel | HTTPS tunnel for web panels |
| Cloudflare DNS | DNS for your domain |

---

## Recommended Hardware

| Players | CPU | RAM | Storage | Network |
|---|---|---|---|---|
| 1-10 | 4 cores / 2.0GHz+ | 8GB | 500GB HDD | 10 Mbps upload |
| 10-30 | 6 cores / 3.0GHz+ | 16GB | 500GB SSD | 30 Mbps upload |
| 30-60 | 8 cores / 3.5GHz+ | 32GB | 1TB NVMe | 100 Mbps upload |
| 60-100 | 12 cores / 4.0GHz+ | 64GB | 2TB NVMe | 500 Mbps upload |

> HDD works but causes slow chunk loading. SSD or NVMe is strongly recommended for 10+ players.  
> WiFi works but Ethernet is always more stable for a server.

---

## RAM Allocation Guide

### Java only (Paper/Vanilla)

| Players | RAM for Minecraft | Notes |
|---|---|---|
| 1-10 | 4-5 GB | Comfortable with plugins |
| 10-30 | 8-10 GB | Required for modpacks |
| 30-60 | 12-16 GB | Heavy plugin load |
| 60-100 | 20-24 GB | Dedicated machine recommended |

### Crossplay: Java + Bedrock (GeyserMC)

Add ~512MB to the Java allocation. Bedrock players go through GeyserMC and do not need a separate server process.

| Players (mixed) | RAM for Minecraft |
|---|---|
| 1-10 | 5 GB |
| 10-30 | 10 GB |
| 30-60 | 16 GB |
| 60-100 | 24 GB |

### Full system RAM budget

| Component | Estimated usage |
|---|---|
| Debian OS | ~500 MB |
| Docker daemon | ~200 MB |
| Portainer | ~150 MB |
| Crafty Controller | ~300 MB |
| Minecraft | see above |
| Buffer | 1-2 GB |

---

## Quick Start

```bash
# 1. Clone the repo on your server
git clone https://github.com/YOUR_USER/minecraft-server.git
cd minecraft-server

# 2. Copy and fill in your variables
cp .env.example .env
nano .env

# 3. Run the installer
sudo bash install.sh
```

After the installer finishes, two manual steps remain:

```bash
sudo tailscale up   # authenticate Tailscale (open the link shown)
sudo playit         # link Playit.gg agent (open the claim link)
```

Then create your Minecraft server inside Crafty and set up tunnels in the Playit.gg dashboard.

---

## Daily Management (Makefile)

Once installed, use `make` for day-to-day operations:

```bash
make help        # list all commands
make status      # status of all services
make logs        # Crafty logs (last 50 lines)
make logs-follow # follow Crafty logs live
make backup      # manual backup of Minecraft data
make update      # pull latest Docker images
make restart     # restart all containers
make ip          # show local and Tailscale IPs
make disk        # disk usage
make ram         # RAM usage
```

Requires `make`: `sudo apt install make -y`

---

## Repo Structure

```
minecraft-server/
├── install.sh            # Full standalone setup script
├── Makefile              # Day-to-day management commands
├── .env.example          # Variable template — copy to .env and fill in
├── .env                  # Your real values — never committed (in .gitignore)
├── .gitignore
├── README.md
├── config/               # Reference config files (generic placeholders)
│   ├── dhcpcd.conf
│   ├── interfaces
│   ├── ufw-rules.sh
│   └── crafty/
│       └── compose.yml
├── docs/                 # Step-by-step guides (English)
│   ├── 01-debian.md
│   ├── 02-docker.md
│   ├── 03-portainer.md
│   ├── 04-crafty.md
│   ├── 05-tailscale.md
│   ├── 06-playit.md
│   ├── 07-cloudflare.md
│   ├── 08-geyser-floodgate.md
│   ├── 09-cloudflare-tunnel.md
│   └── 10-makefile.md
├── docs/es/              # Step-by-step guides (Spanish)
│   └── (same files)
└── scripts/              # Bash scripts called by install.sh and Makefile
    ├── 01-debian-base.sh
    ├── 02-docker.sh
    ├── 03-portainer.sh
    ├── 04-crafty.sh
    ├── 05-tailscale.sh
    ├── 06-playit.sh
    ├── 07-cloudflare-tunnel.sh
    └── install-all.sh
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
| 07 — Cloudflare DNS | [docs/07-cloudflare.md](docs/07-cloudflare.md) |
| 08 — GeyserMC + Floodgate | [docs/08-geyser-floodgate.md](docs/08-geyser-floodgate.md) |
| 09 — Cloudflare Tunnel | [docs/09-cloudflare-tunnel.md](docs/09-cloudflare-tunnel.md) |
| 10 — Makefile | [docs/10-makefile.md](docs/10-makefile.md) |

---

## Access After Setup

| Service | URL |
|---|---|
| Crafty Controller | `https://SERVER_IP:8443` |
| Portainer | `https://SERVER_IP:9443` |
| Minecraft Java | `SERVER_IP:25565` |
| Minecraft Bedrock | `SERVER_IP:19132` |
| Remote admin (Tailscale) | `https://TAILSCALE_IP:8443` |
| Public Java (players) | `YOUR_JAVA_TUNNEL.tun.ply.gg` |
| Public Bedrock (players) | `YOUR_BEDROCK_TUNNEL.tun.ply.gg:PORT` |
| Web panel (Cloudflare) | `https://YOUR_SUBDOMAIN.YOUR_DOMAIN` |

---

## Project Status

| Step | Status |
|---|---|
| Debian base setup | Done |
| Docker | Done |
| Portainer | Done |
| Crafty Controller | Done |
| Minecraft Java server (Paper 1.21.8) | Done |
| Tailscale | Done |
| Playit.gg tunnel (Java) | Done |
| Playit.gg tunnel (Bedrock) | Done |
| Cloudflare DNS | Done |
| Cloudflare Tunnel (web panel) | Done |
| GeyserMC + Floodgate | Pending |
| AuthMe plugin | Pending |
| Backups automation | Pending |

---

---

<a name="español"></a>
# 🇪🇸 Español

## ¿Qué es esto?

Una guía completa y toolkit de automatización para desplegar un servidor de Minecraft propio en una máquina con Debian Linux — sin tocar el router, sin port forwarding y sin IP pública estática.

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
| Cloudflare Tunnel | Túnel HTTPS para paneles web |
| Cloudflare DNS | DNS del dominio |

---

## Hardware Recomendado

| Jugadores | CPU | RAM | Almacenamiento | Red (subida) |
|---|---|---|---|---|
| 1-10 | 4 núcleos / 2.0GHz+ | 8GB | 500GB HDD | 10 Mbps |
| 10-30 | 6 núcleos / 3.0GHz+ | 16GB | 500GB SSD | 30 Mbps |
| 30-60 | 8 núcleos / 3.5GHz+ | 32GB | 1TB NVMe | 100 Mbps |
| 60-100 | 12 núcleos / 4.0GHz+ | 64GB | 2TB NVMe | 500 Mbps |

> HDD funciona pero causa carga lenta de chunks. SSD o NVMe es muy recomendado para 10+ jugadores.  
> WiFi funciona pero Ethernet siempre es más estable para un servidor.

---

## Guía de RAM

### Solo Java (Paper/Vanilla)

| Jugadores | RAM para Minecraft | Notas |
|---|---|---|
| 1-10 | 4-5 GB | Cómodo con plugins |
| 10-30 | 8-10 GB | Necesario para modpacks |
| 30-60 | 12-16 GB | Carga pesada de plugins |
| 60-100 | 20-24 GB | Se recomienda máquina dedicada |

### Crossplay: Java + Bedrock (GeyserMC)

Agrega ~512MB a la asignación de Java. Los jugadores Bedrock pasan por GeyserMC, no necesitan un proceso de servidor separado.

| Jugadores (mixtos) | RAM para Minecraft |
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
| Minecraft | ver arriba |
| Margen de seguridad | 1-2 GB |

---

## Inicio Rápido

```bash
# 1. Clona el repo en tu servidor
git clone https://github.com/YOUR_USER/minecraft-server.git
cd minecraft-server

# 2. Copia y completa tus variables
cp .env.example .env
nano .env

# 3. Ejecuta el instalador
sudo bash install.sh
```

Al terminar el instalador, quedan dos pasos manuales:

```bash
sudo tailscale up   # autenticar Tailscale (abre el enlace que aparece)
sudo playit         # vincular agente de Playit.gg (abre el claim link)
```

Luego crea tu servidor de Minecraft en Crafty y configura los túneles en el dashboard de Playit.gg.

---

## Gestión Diaria (Makefile)

Una vez instalado, usa `make` para las operaciones del día a día:

```bash
make help        # lista todos los comandos
make status      # estado de todos los servicios
make logs        # logs de Crafty (últimas 50 líneas)
make logs-follow # sigue los logs de Crafty en vivo
make backup      # backup manual de los datos de Minecraft
make update      # descarga las últimas imágenes Docker
make restart     # reinicia todos los contenedores
make ip          # muestra IPs local y de Tailscale
make disk        # uso del disco
make ram         # uso de RAM
```

Requiere `make`: `sudo apt install make -y`

---

## Estructura del Repo

```
minecraft-server/
├── install.sh            # Script de instalación completo y standalone
├── Makefile              # Comandos de gestión diaria
├── .env.example          # Plantilla de variables — copia a .env y completa
├── .env                  # Tus valores reales — nunca se sube (en .gitignore)
├── .gitignore
├── README.md
├── config/               # Archivos de configuración de referencia (placeholders)
│   ├── dhcpcd.conf
│   ├── interfaces
│   ├── ufw-rules.sh
│   └── crafty/
│       └── compose.yml
├── docs/                 # Guías paso a paso (inglés)
│   └── 01-debian.md ... 10-makefile.md
├── docs/es/              # Guías paso a paso (español)
│   └── (mismos archivos)
└── scripts/              # Scripts bash llamados por install.sh y Makefile
    ├── 01-debian-base.sh ... 07-cloudflare-tunnel.sh
    └── install-all.sh
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
| 07 — Cloudflare DNS | [docs/es/07-cloudflare.md](docs/es/07-cloudflare.md) |
| 08 — GeyserMC + Floodgate | [docs/es/08-geyser-floodgate.md](docs/es/08-geyser-floodgate.md) |
| 09 — Cloudflare Tunnel | [docs/es/09-cloudflare-tunnel.md](docs/es/09-cloudflare-tunnel.md) |
| 10 — Makefile | [docs/es/10-makefile.md](docs/es/10-makefile.md) |

---

## Acceso Después del Setup

| Servicio | URL |
|---|---|
| Crafty Controller | `https://SERVER_IP:8443` |
| Portainer | `https://SERVER_IP:9443` |
| Minecraft Java | `SERVER_IP:25565` |
| Minecraft Bedrock | `SERVER_IP:19132` |
| Admin remoto (Tailscale) | `https://TAILSCALE_IP:8443` |
| Java público (jugadores) | `YOUR_JAVA_TUNNEL.tun.ply.gg` |
| Bedrock público (jugadores) | `YOUR_BEDROCK_TUNNEL.tun.ply.gg:PORT` |
| Panel web (Cloudflare) | `https://YOUR_SUBDOMAIN.YOUR_DOMAIN` |

---

## Estado del Proyecto

| Paso | Estado |
|---|---|
| Configuración base Debian | Hecho |
| Docker | Hecho |
| Portainer | Hecho |
| Crafty Controller | Hecho |
| Servidor Minecraft Java (Paper 1.21.8) | Hecho |
| Tailscale | Hecho |
| Túnel Playit.gg (Java) | Hecho |
| Túnel Playit.gg (Bedrock) | Hecho |
| DNS Cloudflare | Hecho |
| Cloudflare Tunnel (panel web) | Hecho |
| GeyserMC + Floodgate | Pendiente |
| Plugin AuthMe | Pendiente |
| Backups automaticos | Pendiente |
