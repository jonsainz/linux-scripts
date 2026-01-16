#!/bin/bash

# 1. Empezar de cero para evitar reglas fantasma
sudo ufw --force reset

# 2. Base ultra-segura: Bloquear todo lo entrante
sudo ufw default deny incoming
sudo ufw default allow outgoing

# 3. Acceso total solo vía Tailscale (Tu red privada)
# Esto permite SSH (2222) y cualquier otro servicio interno solo a tus dispositivos
sudo ufw allow in on tailscale0

# 4. Cloudflare Tunnel / Web Pública
# ¡NO ABRIMOS EL 80 NI EL 443! 
# El binario 'cloudflared' se conecta a Cloudflare por fuera.
# Tu servidor web (Nginx/Apache) debe escuchar en 127.0.0.1:80 internamente.

# 5. Certbot (Opcional - Solo si usas HTTP-01)
# Si usas DNS-01 challenge con Cloudflare, borra esta línea.
# sudo ufw allow 80/tcp comment 'Solo para renovar Let's Encrypt'

# 6. Activar
sudo ufw enable

# 7. Ver resultado
sudo ufw status verbose
