# 09 — Cloudflare Tunnel

Cloudflare Tunnel expone servicios locales a internet por HTTPS sin port forwarding ni abrir puertos en el router. El tunel inicia una conexion saliente desde tu servidor a la red de Cloudflare.

## Requisitos

- Un dominio agregado a Cloudflare (cualquier TLD soportado)
- Cuenta de Cloudflare (plan gratuito)
- `cloudflared` instalado en el servidor

---

## Instalacion

```bash
curl -L https://pkg.cloudflare.com/cloudflare-main.gpg | sudo tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared any main" | sudo tee /etc/apt/sources.list.d/cloudflared.list
sudo apt update
sudo apt install cloudflared -y
```

---

## Autenticarse con Cloudflare

```bash
cloudflared tunnel login
```

Abre un enlace en el navegador. Selecciona tu dominio y autoriza.

---

## Crear el tunel

```bash
cloudflared tunnel create YOUR_TUNNEL_NAME
```

Genera un archivo de credenciales en `~/.cloudflared/TUNNEL_ID.json`. Mantenlo en secreto.

---

## Archivo de configuracion

Crea `~/.cloudflared/config.yml`:

```yaml
tunnel: YOUR_TUNNEL_ID
credentials-file: /home/YOUR_USER/.cloudflared/YOUR_TUNNEL_ID.json

ingress:
  - hostname: YOUR_SUBDOMAIN.YOUR_DOMAIN
    service: https://localhost:YOUR_LOCAL_PORT
    originRequest:
      noTLSVerify: true
  - service: http_status:404
```

- `noTLSVerify: true` es necesario si el servicio local usa certificado autofirmado.
- La ultima entrada `http_status:404` es obligatoria como catch-all.

---

## Crear registro DNS

```bash
cloudflared tunnel route dns YOUR_TUNNEL_NAME YOUR_SUBDOMAIN.YOUR_DOMAIN
```

Crea automaticamente un registro CNAME en Cloudflare DNS apuntando al tunel.

---

## Instalar como servicio del sistema

```bash
sudo cloudflared --config /home/YOUR_USER/.cloudflared/config.yml service install
sudo systemctl enable cloudflared
sudo systemctl start cloudflared
```

---

## Verificacion

```bash
sudo systemctl status cloudflared
```

Accede al servicio en `https://YOUR_SUBDOMAIN.YOUR_DOMAIN`.

---

## Notas

- Cloudflare Tunnel solo funciona para servicios HTTP/HTTPS. No puede tunelizar trafico TCP/UDP de juegos.
- Para conexiones de jugadores de Minecraft, usa Playit.gg (ver `06-playit.md`).
- Cloudflare emite un certificado SSL gratuito automaticamente.
