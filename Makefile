# =============================================================================
# Minecraft Server — Makefile
# =============================================================================
# Usage: make <target>
# Requires: make, bash, sudo
# All complex logic lives in scripts/. This file is only an entry point.
# =============================================================================

SHELL := /bin/bash
SCRIPTS := scripts
ENV_FILE := .env

.PHONY: help install debian docker portainer crafty tailscale playit tunnel \
        status restart logs backup update check-env

# Default target
all: help

# -----------------------------------------------------------------------------
# Help
# -----------------------------------------------------------------------------

help: ## Show available commands
	@echo ""
	@echo "  Minecraft Server — Available commands"
	@echo "  ======================================"
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_-]+:.*##/ { printf "  \033[36mmake %-15s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
	@echo ""

# -----------------------------------------------------------------------------
# Setup
# -----------------------------------------------------------------------------

check-env: ## Verify .env file exists
	@if [ ! -f "$(ENV_FILE)" ]; then \
		echo "ERROR: .env file not found."; \
		echo "  Copy .env.example to .env and fill in your values:"; \
		echo "  cp .env.example .env && nano .env"; \
		exit 1; \
	fi
	@echo "✓ .env file found"

install: check-env ## Run full setup (all steps in order)
	@echo ""
	@echo "  Starting full server setup..."
	@echo "  =============================="
	@$(MAKE) debian
	@$(MAKE) docker
	@$(MAKE) portainer
	@$(MAKE) crafty
	@$(MAKE) tailscale
	@$(MAKE) playit
	@echo ""
	@echo "  =============================="
	@echo "  Setup complete."
	@echo "  Manual steps remaining:"
	@echo "    1. sudo tailscale up"
	@echo "    2. sudo playit"
	@echo "    3. make tunnel (when Cloudflare domain is ready)"
	@echo "  =============================="

debian: check-env ## Configure Debian base (static IP, firewall, packages)
	@echo "==> Configuring Debian base..."
	@sudo bash $(SCRIPTS)/01-debian-base.sh

docker: check-env ## Install Docker
	@echo "==> Installing Docker..."
	@sudo bash $(SCRIPTS)/02-docker.sh

portainer: ## Install Portainer
	@echo "==> Installing Portainer..."
	@bash $(SCRIPTS)/03-portainer.sh

crafty: check-env ## Install Crafty Controller
	@echo "==> Installing Crafty Controller..."
	@sudo bash $(SCRIPTS)/04-crafty.sh

tailscale: ## Install Tailscale
	@echo "==> Installing Tailscale..."
	@sudo bash $(SCRIPTS)/05-tailscale.sh

playit: ## Install Playit.gg tunnel agent
	@echo "==> Installing Playit.gg..."
	@sudo bash $(SCRIPTS)/06-playit.sh

tunnel: check-env ## Setup Cloudflare Tunnel
	@echo "==> Setting up Cloudflare Tunnel..."
	@sudo bash $(SCRIPTS)/07-cloudflare-tunnel.sh

# -----------------------------------------------------------------------------
# Operations
# -----------------------------------------------------------------------------

status: ## Show status of all services
	@echo ""
	@echo "  Service Status"
	@echo "  =============="
	@echo ""
	@echo "  [Docker containers]"
	@docker ps --format "  {{.Names}}\t{{.Status}}\t{{.Ports}}" 2>/dev/null || echo "  Docker not running"
	@echo ""
	@echo "  [Tailscale]"
	@systemctl is-active tailscaled 2>/dev/null && tailscale ip -4 2>/dev/null || echo "  Not running"
	@echo ""
	@echo "  [Playit.gg]"
	@systemctl is-active playit 2>/dev/null || echo "  Not running"
	@echo ""
	@echo "  [Cloudflare Tunnel]"
	@systemctl is-active cloudflared 2>/dev/null || echo "  Not running"
	@echo ""

restart: ## Restart all Docker containers
	@echo "==> Restarting all containers..."
	@docker restart $$(docker ps -q) 2>/dev/null || echo "No containers running"
	@echo "✓ Done"

logs: ## Show Crafty Controller logs (last 50 lines)
	@docker logs crafty --tail 50 2>/dev/null || echo "Crafty container not found"

logs-follow: ## Follow Crafty Controller logs live
	@docker logs crafty -f 2>/dev/null || echo "Crafty container not found"

backup: ## Run manual backup of Minecraft server data
	@echo "==> Running manual backup..."
	@BACKUP_DIR="/srv/minecraft/crafty/backups/manual"; \
	TIMESTAMP=$$(date +%Y%m%d_%H%M%S); \
	mkdir -p "$$BACKUP_DIR"; \
	tar -czf "$$BACKUP_DIR/minecraft_$$TIMESTAMP.tar.gz" /srv/minecraft/crafty/servers/ 2>/dev/null; \
	echo "✓ Backup saved to $$BACKUP_DIR/minecraft_$$TIMESTAMP.tar.gz"

update: ## Pull latest Docker images and restart containers
	@echo "==> Updating Docker images..."
	@cd /srv/minecraft/crafty && docker compose pull && docker compose up -d
	@docker pull portainer/portainer-ce:latest
	@docker restart portainer
	@echo "✓ Update complete"

# -----------------------------------------------------------------------------
# Utilities
# -----------------------------------------------------------------------------

ip: ## Show server IPs (local and Tailscale)
	@echo ""
	@echo "  Local IP:    $$(ip -4 addr show | grep inet | grep -v 127 | grep -v 100.64 | awk '{print $$2}' | head -1)"
	@echo "  Tailscale:   $$(tailscale ip -4 2>/dev/null || echo 'not connected')"
	@echo ""

disk: ## Show disk usage
	@df -h /srv/minecraft 2>/dev/null || df -h /

ram: ## Show RAM usage
	@free -h
