# Seguirdad en SSH

Instrucciones para hacer SSH mas seguro.

- Desactivar login por contraseña
- Usar claves SSH
- No usar root directamente
- Fail to ban (Anti fuerza bruta)

## Instrucciones

1) Desactivar login por contraseña:

sudo nano /etc/ssh/ssh_config

PasswordAuthentication no <br>
ChallengeResponseAuthentication no <br>
PubkeyAuthentication yes <br>

sudo systemctl restart sshd

2) Usar claves SSH

* Esto en el ordenador que uses para entrar a traves de ssh <br>
ssh-keygen -t ed25519
- Enter a todo. pon una passphrase si quieres mas seguridad

ssh-copy-id -p 2222 usuario@IP_DEL_SERVIDOR
- Copia la clave al servidor

ssh -p 2222 usuario@IP_DEL_SERVIDOR
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

Port 2222 <br>
PermitRootLogin no <br>
PasswordAuthentication no <br>
ChallengeResponseAuthentication no <br>
PubkeyAuthentication yes <br>
AllowUsers siz <br>



si queires que se abra a internet, tienes que abrir el puerto al firewall y en el modem.
tn hay que crear una IP fija con DUCKDNS porque nuestra IP es dinamica

Antes de abrirlo a internet tienes que tener esto OK:

Antes de abrirlo a Internet, asegúrate de tener:

✔️ Claves SSH funcionando
✔️ PasswordAuthentication no
✔️ PermitRootLogin no
✔️ Fail2ban activo
✔️ Usuario normal + sudo


Por ultimo:

7️⃣ Alternativa MUCHO más segura (te la dejo caer 😏)

👉 No exponer SSH directamente

WireGuard

Tailscale

Zerotier

Te conectas como si estuvieras en LAN → SSH normal
🔒 Casi imposible de atacar



-------------------

mkdir -p ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

ssh-copy-id -p 2222 siz@IP_DEL_SERVIDOR


y probar: ssh -p 2222 siz@IP_DEL_SERVIDOR



