# Proyecto Servidor SSH

Este proyecto instala el servidor **SSH OpenSSH Server** e Instala el Firewall **ufw**.
Despues cambia al puerto por defecto, que es el **puerto 22** por el **puerto 2222**, menos comun y asi evitamos ataques automaticos.
Tambien configura el Firewall para permitir la entrada en ese puerto.

---

## Caracteristicas

- Te obliga a instalar el script como super usuario.
- Instala el servidor OpenSSH (si no esta instalado).
- Cambia el puerto por defecto **22** por el puerto **2222**.
- Cierra el puerto ** 22**.
- Habilita y configura el firewall **ufw**.
- Abre el puerto **2222** en el firewall.
- Reinicia el servidor SSH para activar cambios.
- El usuario no necesita interactuar.
- Reinicia automaticamente el sistema.

---

## Requisitos

- Sistema operativo basado en Linux (Que use apt como Ubuntu...).
- Permisos de Superusuario.
- Conexion a internet para instalar paquetes.

---

## Uso

1. Clona el repositorio

	bash
	gitclone https://github.com/......git

2. Ejecuta el script

	bash
	./instalar_ssh.sh

---

# Seguridad en SSH:

## Caracteristicas:

- Claves SSH / Hardering SSH
- Fail2ban
- Tailscale

(Mezclar estas dos mejor)

- Desactivar login por contraseña
- Usar claves SSH
- No usar root directamente
- Fail to ban (Anti fuerza bruta)
- Tailscale

## Instrucciones

1) Claves SSH
 En el archivo de configuracion de SSH: /etc/ssh/sshd_config (En el PC Servidor)
 (Como se comporta el PC cuando alguien se conecta por SSH)

Port 2222								Cambia el puerto
PermitRootLogin no						Prohibe iniciar sesion directamente en root
PasswordAuthentication yes 				Permite entrar con contraseña de usuario (Cuando tengamos las claves SSH, cambiamos a no))
ChallengeResponseAuthentication no		Desactiva formas de autentificacion de "Reto-respuesta"
PubkeyAuthentication yes				Permite usar las llaves SSH para entrar sin contraseña.
AllowUsers 								Usuarios permitidos


sudo systemctl restart sshd

2) Crear claves SSH en el ordenador Cliente. el ordenador donde quieres acceder al servidor

	ssh-keygen -t ed25519 						Genera las claves. ed25519 son claves modernas.

ssh-copy-id -p 2222 usuario@IP_DEL_SERVIDOR 	Copia las claves al servidor (Puedes crear clave para mas seguirdad, passphrase)

3) despues editamos otra vez el archivo sshd_conifg

cmabiamos el PasswordAuthentication yes a no

sudo systemctl restart sshd

4) Instalamos fail2ban

sudo dnf install fail2ban -y 
sudo systemctl enable --now fail2ban

5) Abrir SSH a internet

- Tailscale. Esta aplicacion crea una VPN y no necesitas abrir puertos en el router para conectarte via SSH

Instalas Tailscale en el ordenador servidor y cliente. crea IPS para cada ordenador. Sin aplicaciones instaladas no se puede acceder
Tienes que usar la IP que te da Tailscale para acceder por ssh. Descargar en la web oficial

Instalacion Servidor:

TAILSCALE: (genera un VPN para ssh, ASI NOI ABRO PUERTOS EN MI ROUTER )

curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up

sudo ufw allow in on tailscale0 (TENGO UN SCRIPT DE UFW EN SECURITY. ESO CONFIGURA TOTALEMTNE PARA SOLO USAR TAILSCALE)

Lo que pasará ahora:

    Aparecerá un enlace (URL) en la terminal.

    Cópialo y pégalo en el navegador de tu ordenador personal.

    Inicia sesión con tu cuenta

6) Alias SSH

- Como hacer un alias para no tener que escribir USUARIO@IP -p 2222, usarias solo NOMBRE

ej: en vez de usar:
ssh -p 2222 usuario@192.168.1.45 
usarias:
ssh NOMBRE



- Como crear el Alias en tu ordnador cliente:

editar o crear este archivo:

~/.ssh/conifg (CConfiguracion de como te conectas a otros servidores por SSH)

Host ALIAS
    HostName IP
    User tu_usuario_de_fedora
    Port 2222
    IdentityFile ~/.ssh/id_rsa (Por defecto) -> mirar en carpeta ~/.ssh/ un archivo .pub. Ese es el nombre a poner

* Si no quieres meter la contraseña passphrase de las llaves SSH cada vez, puedes incluir esto en Host ALIAS:
SOLO PARA MAC   
    UseKeychain yes
    
Este meterlo en mac y linux, da igual
AddKeysToAgent yes (Esto hace que si meto una vezx la contraseña no tenga que meterla mas)

en fedora:
sudo dnf install openssh-askpass

luego cuando entres en el escritorio te pide una vez la contraseña y ya esta


Para LINUX:

permisos: 
chmod 700 ~/.ssh
chmod 600 config
sudo chown -R TUUSUARIO ~/.ssh

6) Usos SSH

* Entrar por ssh

	ssh ALIAS

* Copiar archivos:
- No hay que conectarse por ssh. lo tienes que hacer desde tu terminal.
  
ej:
scp -P 2222 usuario@192.168.1.45:/home/usuario/documento.pdf ~/Downloads/

Con Alias: (MIRAR ESTO)
scp -P ALIAS:documento.pdf ~/Downloads/
