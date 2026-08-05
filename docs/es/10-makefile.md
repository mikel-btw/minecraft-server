# 10 — Makefile

El Makefile es el punto de entrada principal para gestionar el servidor. En lugar de recordar comandos largos o que script ejecutar, usas `make <target>`.

Toda la logica compleja vive en `scripts/`. El Makefile solo los llama en el orden correcto.

---

## Requisitos

```bash
sudo apt install make -y
```

---

## Uso

```bash
make <target>
```

Ejecuta `make help` para ver todos los comandos disponibles en cualquier momento.

---

## Targets

### Setup

| Comando | Que hace |
|---|---|
| `make install` | Ejecuta todos los pasos de setup en orden |
| `make debian` | Configura Debian base (IP estatica, firewall, paquetes) |
| `make docker` | Instala Docker |
| `make portainer` | Instala Portainer |
| `make crafty` | Instala Crafty Controller |
| `make tailscale` | Instala Tailscale |
| `make playit` | Instala Playit.gg |
| `make tunnel` | Configura Cloudflare Tunnel |

### Operaciones (dia a dia)

| Comando | Que hace |
|---|---|
| `make status` | Muestra estado de todos los servicios (Docker, Tailscale, Playit, Cloudflare) |
| `make restart` | Reinicia todos los contenedores Docker |
| `make logs` | Muestra las ultimas 50 lineas de logs de Crafty |
| `make logs-follow` | Sigue los logs de Crafty en vivo |
| `make backup` | Hace un backup manual de los datos del servidor Minecraft |
| `make update` | Descarga las ultimas imagenes Docker y reinicia los contenedores |

### Utilidades

| Comando | Que hace |
|---|---|
| `make ip` | Muestra la IP local y la IP de Tailscale |
| `make disk` | Muestra el uso del disco |
| `make ram` | Muestra el uso de RAM |
| `make help` | Lista todos los comandos disponibles |

---

## Replicar el servidor desde cero

```bash
git clone https://github.com/YOUR_USER/minecraft-server.git
cd minecraft-server
cp .env.example .env
nano .env        # completa tus valores
make install
```

Despues de `make install`, quedan dos pasos manuales:

```bash
sudo tailscale up   # autenticar Tailscale
sudo playit         # vincular agente de Playit.gg
```

---

## Como funciona internamente

El Makefile llama los scripts de la carpeta `scripts/`:

```
make debian   →  sudo bash scripts/01-debian-base.sh
make docker   →  sudo bash scripts/02-docker.sh
make crafty   →  sudo bash scripts/04-crafty.sh
...
```

Todos los scripts leen las variables del archivo `.env`. Nunca subas tu `.env` (esta en `.gitignore`).

---

## Agregar nuevos targets

Para agregar un nuevo comando, agrega un target al Makefile con este patron:

```makefile
tu-target: ## Descripcion que aparece en make help
	@bash scripts/tu-script.sh
```

El comentario `##` es lo que aparece en `make help`. Siempre declara los targets que no son archivos en `.PHONY`.
