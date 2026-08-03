# 05 — Tailscale (Private Remote Access)

Tailscale creates a private VPN between your devices. Used for SSH and admin panel access from anywhere without exposing ports publicly.

## Installation on the server

```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up
```

Open the link shown in the terminal, log in with your account (GitHub/Google), and authorize the device.

## Enable on boot

```bash
sudo systemctl enable tailscaled
sudo systemctl is-enabled tailscaled  # should return: enabled
```

## Get Tailscale IP

```bash
tailscale ip -4
```

## Install on your other devices

Download from https://tailscale.com/download and log in with the same account. All devices in the same tailnet can reach each other directly.

## SSH from anywhere

```bash
ssh YOUR_USER@TAILSCALE_IP
```

## Notes

- Tailscale manages its own DNS via `/etc/resolv.conf`. Do not edit that file manually.
- The server must have outbound internet access for Tailscale to connect (it initiates outbound, no port forwarding needed).
