# 01 — Debian Base Setup

## Requirements

- Debian 12+ installed (CLI only, no desktop environment)
- During installation, select only:
  - `SSH server`
  - `standard system utilities`
- User with sudo privileges

---

## Variables used (from `.env`)

```
ADMIN_USER=admin
SERVER_IP=0.0.0.0
GATEWAY_IP=0.0.0.1
WIFI_INTERFACE=wlp0s0
WIFI_SSID=YOUR_SSID
WIFI_PASSWORD=YOUR_PASSWORD
TIMEZONE=America/Bogota
```

---

## 1. Add user to sudo

```bash
su -
apt install sudo
usermod -aG sudo YOUR_USER
exit
# Log out and back in
sudo whoami  # should return: root
```

---

## 2. Static IP via dhcpcd

Edit `/etc/dhcpcd.conf` and add at the end:

```
interface YOUR_INTERFACE
static ip_address=SERVER_IP/24
static routers=GATEWAY_IP
static domain_name_servers=8.8.8.8 1.1.1.1
```

Edit `/etc/network/interfaces`:

```
source /etc/network/interfaces.d/*

auto lo
iface lo inet loopback

auto YOUR_INTERFACE
iface YOUR_INTERFACE inet static
    address SERVER_IP
    netmask 255.255.255.0
    gateway GATEWAY_IP
    wpa-ssid YOUR_SSID
    wpa-psk YOUR_PASSWORD
```

Apply:

```bash
sudo ifdown YOUR_INTERFACE && sudo ifup YOUR_INTERFACE
```

---

## 3. Disable laptop sleep/suspend

```bash
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
```

---

## 4. Install base packages

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl wget git ufw fail2ban unattended-upgrades gnupg btop
```

---

## 5. Automatic security updates

```bash
sudo dpkg-reconfigure unattended-upgrades
# Select: Yes
```

---

## 6. Firewall

```bash
sudo ufw allow ssh
sudo ufw enable
```

---

## 7. btop on terminal start (optional)

```bash
echo "btop" >> ~/.bashrc
```

---

## Verification

```bash
ip a                    # Confirm static IP
ping -c 3 8.8.8.8      # Confirm internet
sudo ufw status         # Confirm firewall active
systemctl status ssh    # Confirm SSH running
```
