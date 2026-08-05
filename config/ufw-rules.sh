#!/bin/bash
# UFW firewall rules for the Minecraft server
# Run as root after installing UFW

# Allow SSH
ufw allow 22/tcp

# Allow Minecraft Java
ufw allow 25565/tcp

# Allow Minecraft Bedrock
ufw allow 19132/udp

# Enable firewall
ufw --force enable

ufw status
