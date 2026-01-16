#!/bin/bash

# Carpeta destino
DESTINO="$HOME/logs"

# Fecha actual
FECHA=$(date +"%Y-%m-%d_%H-%M-%S")

# Crear carpeta si no existe
mkdir -p "$DESTINO/$FECHA"

# Copiar logs de Apache
sudo cp /var/log/apache2/access.log "$DESTINO/$FECHA/" 2>/dev/null
sudo cp /var/log/apache2/error.log "$DESTINO/$FECHA/" 2>/dev/null

# Copiar log de SSH
sudo cp /var/log/auth.log "$DESTINO/$FECHA/" 2>/dev/null

# Copiar log de UFW
sudo cp /var/log/ufw.log "$DESTINO/$FECHA/" 2>/dev/null

# Copiar logs de Fail2Ban
sudo cp /var/log/fail2ban.log "$DESTINO/$FECHA/" 2>/dev/null

# Ajustar permisos para tu usuario
sudo chown -R "$USER:$USER" "$DESTINO/$FECHA"

echo "Logs copiados en: $DESTINO/$FECHA"
