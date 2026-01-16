#!/bin/bash

sudo fail2ban-client status

sudo fail2ban-client status sshd


# 1. Detectar el usuario real que lanzó el sudo
# Si no hay sudo, usamos el usuario actual
REAL_USER=${SUDO_USER:-$(whoami)}
REAL_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)

# 2. Definir destino en la carpeta personal del usuario real
DESTINO="$REAL_HOME/mis_logs_fail2ban"

# 3. Crear la carpeta
mkdir -p "$DESTINO"

# 4. Copiar el log
FECHA=$(date +"%Y-%m-%d_%H-%M")
cp /var/log/fail2ban.log "$DESTINO/fail2ban_$FECHA.log"

# 5. Cambiar el dueño de la CARPETA y el ARCHIVO al usuario real
# Esto arregla el problema de que root sea el dueño
chown -R "$REAL_USER:$REAL_USER" "$DESTINO"

echo "Hecho. El log se ha guardado en: $DESTINO"
echo "El dueño de los archivos es: $REAL_USER"
