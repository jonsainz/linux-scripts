#!/bin/bash

DESTINO="$HOME/logs"
FECHA=$(date +"%Y-%m-%d_%H-%M-%S")

mkdir -p "$DESTINO/$FECHA"

# Copiar todos los logs con sudo
sudo cp /var/log/apache2/access.log "$DESTINO/$FECHA/" 2>/dev/null
sudo cp /var/log/apache2/error.log "$DESTINO/$FECHA/" 2>/dev/null
sudo cp /var/log/auth.log "$DESTINO/$FECHA/" 2>/dev/null
sudo cp /var/log/ufw.log "$DESTINO/$FECHA/" 2>/dev/null
sudo cp /var/log/fail2ban.log "$DESTINO/$FECHA/" 2>/dev/null

# Cambiar propietario al usuario actual
sudo chown -R "$USER:$USER" "$DESTINO/$FECHA"

echo "Logs copiados en: $DESTINO/$FECHA"
