# 01 — Configuración Base de Debian

## Requisitos

- Debian 12+ instalado (solo CLI, sin entorno de escritorio)
- Durante la instalación, seleccionar únicamente:
  - `SSH server`
  - `standard system utilities`
- Usuario con privilegios sudo

---

## Variables usadas (desde `.env`)

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

## 1. Agregar usuario a sudo

```bash
su -
apt install sudo
usermod -aG sudo YOUR_USER
exit
# Cerrar sesion y volver a entrar
sudo whoami  # debe responder: root
```

---

## 2. IP estática via dhcpcd

Editar `/etc/dhcpcd.conf` y agregar al final:

```
interface YOUR_INTERFACE
static ip_address=SERVER_IP/24
static routers=GATEWAY_IP
static domain_name_servers=8.8.8.8 1.1.1.1
```

Editar `/etc/network/interfaces`:

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

Aplicar:

```bash
sudo ifdown YOUR_INTERFACE && sudo ifup YOUR_INTERFACE
```

---

## 3. Deshabilitar suspensión del laptop

```bash
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
```

---

## 4. Instalar paquetes base

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl wget git ufw fail2ban unattended-upgrades gnupg btop
```

---

## 5. Actualizaciones de seguridad automáticas

```bash
sudo dpkg-reconfigure unattended-upgrades
# Seleccionar: Yes
```

---

## 6. Firewall

```bash
sudo ufw allow ssh
sudo ufw enable
```

---

## 7. btop al iniciar terminal (opcional)

```bash
echo "btop" >> ~/.bashrc
```

---

## Verificación

```bash
ip a                    # Confirmar IP estática
ping -c 3 8.8.8.8      # Confirmar internet
sudo ufw status         # Confirmar firewall activo
systemctl status ssh    # Confirmar SSH corriendo
```
