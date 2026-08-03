# 06 — Playit.gg (Public Tunnel for Players)

Playit.gg creates public tunnels for Minecraft (Java TCP + Bedrock UDP) without port forwarding or router access.

## Installation

```bash
sudo apt install gnupg -y

curl -SsL https://packages.playit.gg/keys/playit.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/playit.gpg >/dev/null
sudo chmod 0644 /usr/share/keyrings/playit.gpg
sudo curl -fsSL -o /etc/apt/sources.list.d/playit.list https://packages.playit.gg/repo-files/playit-debian.list
sudo apt update
sudo apt install playit
```

## Link to your account

```bash
sudo playit
```

Open the claim link shown in the terminal and log in at playit.gg.

## Enable on boot

```bash
sudo systemctl enable playit
sudo systemctl start playit
```

## Creating tunnels (in the playit.gg dashboard)

### Java tunnel
- Tunnel type: Minecraft Java
- Local IP: 127.0.0.1
- Local port: 25565

### Bedrock tunnel
- Tunnel type: Minecraft Bedrock
- Local IP: 127.0.0.1
- Local port: 19132

## Player connection address

After creating the tunnel, Playit assigns a public address like:

```
something.tun.ply.gg
```

Players connect to that address in Minecraft. No port needed for the default Java tunnel.

## Check tunnel status

```bash
sudo systemctl status playit
sudo journalctl -u playit --no-pager
```
