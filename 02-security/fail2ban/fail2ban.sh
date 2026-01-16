#!/bin/bash

sudo fail2ban-client status

sudo fail2ban-client status sshd


#!/bin/bash

# 1. Detectar el usuario actual y su carpeta HOME
USUARIO=$(whoami)
DESTINO="/home/$USUARIO/logs"

# 2. Crear la carpeta si no existe
# -p asegura que no de error si ya existe y crea la ruta completa
mkdir -p "$DESTINO"

# 3. Copiar el log
# Usamos sudo cp porque el log original suele ser solo lectura para root
FECHA=$(date +"%Y-%m-%d_%H-%M")
sudo cp /var/log/fail2ban.log "$DESTINO/fail2ban_$FECHA.log"

# 4. Cambiar el dueño del nuevo archivo al usuario actual
# (Al usar sudo cp, el dueño sería root; esto lo devuelve a tu usuario)
sudo chown $USUARIO:$USUARIO "$DESTINO/fail2ban_$FECHA.log"

echo -e "\nHola $USUARIO, el log de fail2ban se ha copiado a: $DESTINO\n"

