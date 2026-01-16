# Seguirdad en SSH BORRAR. MIRAR CON EL OTRO


- BORRAR MIRAR CON EL OTRO




--

---
Instrucciones para hacer SSH mas seguro.

- Desactivar login por contraseña
- Usar claves SSH
- No usar root directamente
- Fail to ban (Anti fuerza bruta)

## Instrucciones

1) Desactivar login por contraseña:

sudo nano /etc/ssh/sshd_config

PasswordAuthentication yes<br>
ESTO LUEGO HAY QUE PONER NO AL ACABAR<br>
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

- en sshd_config

PermitRootLogin no

sudo systemctl ssh restart

4) Fail to ban (Bloquea ataques automaticos)

sudo dnf install fail2ban -y
sudo systemctl enable --now fail2ban

## Resumen

en /etc/ssh/sshd_config

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


TAILSCALE: (genera un VPN para ssh, ASI NOI ABRO PUERTOS EN MI ROUTER )

curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up
sudo ufw allow in on tailscale0

Lo que pasará ahora:

    Aparecerá un enlace (URL) en la terminal.

    Cópialo y pégalo en el navegador de tu ordenador personal.

    Inicia sesión con tu cuenta

SUPER CLAVE:

si quieres meter mas ordenadores con claves SSH, tiene que volver a cambiar dento de sshd_config:

PasswordAuthentication yes

con esto crear las claves como antes. Despues de crear las claves vuelve a cambiarlo a NO

-------------------
si te da algun error comprueba esto antes de vovler a hacer ssh-copy.....

mkdir -p ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

ssh-copy-id -p 2222 siz@IP_DEL_SERVIDOR


y probar: ssh -p 2222 siz@IP_DEL_SERVIDOR



