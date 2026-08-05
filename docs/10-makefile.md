# 10 — Makefile

The Makefile is the main entry point for managing the server. Instead of remembering long commands or which script to run, you use `make <target>`.

All complex logic lives in `scripts/`. The Makefile only calls them in the right order.

---

## Requirements

```bash
sudo apt install make -y
```

---

## Usage

```bash
make <target>
```

Run `make help` to list all available commands at any time.

---

## Targets

### Setup

| Command | What it does |
|---|---|
| `make install` | Runs all setup steps in order |
| `make debian` | Configures Debian base (static IP, firewall, packages) |
| `make docker` | Installs Docker |
| `make portainer` | Installs Portainer |
| `make crafty` | Installs Crafty Controller |
| `make tailscale` | Installs Tailscale |
| `make playit` | Installs Playit.gg |
| `make tunnel` | Sets up Cloudflare Tunnel |

### Operations (day to day)

| Command | What it does |
|---|---|
| `make status` | Shows status of all services (Docker, Tailscale, Playit, Cloudflare) |
| `make restart` | Restarts all Docker containers |
| `make logs` | Shows last 50 lines of Crafty logs |
| `make logs-follow` | Follows Crafty logs live |
| `make backup` | Runs a manual backup of Minecraft server data |
| `make update` | Pulls latest Docker images and restarts containers |

### Utilities

| Command | What it does |
|---|---|
| `make ip` | Shows local and Tailscale IPs |
| `make disk` | Shows disk usage |
| `make ram` | Shows RAM usage |
| `make help` | Lists all available commands |

---

## Replicating the server from scratch

```bash
git clone https://github.com/YOUR_USER/minecraft-server.git
cd minecraft-server
cp .env.example .env
nano .env        # fill in your values
make install
```

After `make install`, two manual steps remain:

```bash
sudo tailscale up   # authenticate Tailscale
sudo playit         # link Playit.gg agent
```

---

## How it works internally

The Makefile calls scripts from the `scripts/` folder:

```
make debian   →  sudo bash scripts/01-debian-base.sh
make docker   →  sudo bash scripts/02-docker.sh
make crafty   →  sudo bash scripts/04-crafty.sh
...
```

All scripts read variables from `.env`. Never commit your `.env` file (it is in `.gitignore`).

---

## Adding new targets

To add a new command, add a target to the Makefile following this pattern:

```makefile
your-target: ## Description shown in make help
	@bash scripts/your-script.sh
```

The `##` comment is what appears in `make help`. Always declare non-file targets in `.PHONY`.
