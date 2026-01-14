# Seguirdad en SSH

Instrucciones para hacer SSH mas seguro.

- Desactivar login por contraseña
- Usar claves SSH
- No usar root directamente
- Fail to ban (Anti fuerza bruta)

## Instrucciones

1) Desactivar login por contraseña:

sudo nano /etc/ssh/ssh_config

PasswordAuthentication no
ChallengeResponseAuthentication no
PubkeyAuthentication yes             (

sudo systemctl restart ssh

2) Usar claves SSH

ssh-keygen -t ed25519
- Enter a todo. pon una passphrase si quieres mas seguridad

ssh-copy-id -p 2222 usuario@IP_DEL_SERVIDOR
- Copia la clave al servidor

ssh-copy-id -p 2222 usuario@IP_DEL_SERVIDOR
- Si entra sin contraseña. Todo correcto

3) No usar root directamente

- en ssh_config

PermitRootLogin no

sudo systemctl ssh restart

4) Fail to ban (Bloquea ataques automaticos)

sudo dnf install fail2ban -y
sudo systemctl enable --now fail2ban

## Resumen

en /etc/ssh/ssh_config

Port 2222
PermitRootLogin no
PasswordAuthentication no
ChallengeResponseAuthentication no
PubkeyAuthentication yes
AllowUsers siz



si queires que se abra a internet, tienes que abrir el puerto al firewall y en el modem.
tn hay que crear una IP fija con DUCKDNS porque nuestra IP es dinamica

Antes de abrirlo a internet tienes que tener esto OK:

Antes de abrirlo a Internet, asegúrate de tener:

✔️ Claves SSH funcionando
✔️ PasswordAuthentication no
✔️ PermitRootLogin no
✔️ Fail2ban activo
✔️ Usuario normal + sudo


