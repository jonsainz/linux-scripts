#!/bin/bash

# Script para instalar un servidor SSH, cambiar el puerto y configurar Firewall.
# Esta echo para Ubuntu.


# Comprobacion de usuario. Solo se puede ejecturar de root  porque vamos a instalar y modificar archivos del sistema.

# $EUID -> Variable especial que almacena el ID del usuario efectivo (Effetive User ID)
# Los usuarios se identifican por un numero de identificacion llamado UID (User ID)
# El Superusuario o Administrador del sistema tiene un UID Cero(0). Root


#----------------------------
# Comprobacion de superusuario
#-----------------------------


if [[ $EUID -ne 0 ]]; then

# if [[ ]]; then
# fi

# -ne -> Not Equal

	echo "Para ejecutar este script que instalala el servidor SSH y sus configuraciones hace falta ejecutarlo como Root"
	exit 1
	# exit 1 -> Termina el script
fi

#-----------------------------
# Pregunta si quiere continuar
#-----------------------------

echo -e "\nAtencion: Este script reiniciara el sistema despues de acabar la instalacion\n"
echo -n "Desea continuar? (s/n):"

read opcion
case "$opcion" in
	s | S)
		echo "Continuando con la instalacion..."
		;;
	n | N)
		echo "Saliendo del script de instalacion..."
		exit 0
		;;
	*)
		echo "Opcion no valida. Saliendo del script de instalacion..."
		exit 1
		;;
esac

#-----------------------------
# Actualizar sistema operativo
#-----------------------------

echo "Actualizando paquetes..."
sudo apt update -y
sudo apt upgrade -y

#-----------------------
# Instalar SSH y Firewall
#------------------------

echo "Instalando servidor SSH..."
sudo apt install openssh-server -y
echo "Instalando Firewall..."
sudo apt install ufw -y

#---------------------
# Iniciar Servidor SSH
#---------------------

sudo systemctl start ssh
sudo systemctl enable ssh

#--------------------------------------------------------
# Cambiando puerto por defecto 22 a 2222 del servidor SSH
#--------------------------------------------------------

echo "Cambiando puerto del SSH a 2222..."

# sed -> Comando para editar textos

sudo sed -i 's/^#Port 22/Port 2222/' /etc/ssh/sshd_config

	# -i -> Inplace: Cambios directamente en el archivo
	# 's/PATRON/REEMMPLAZO'
		# ^#Port 22 -> Busca una linea que comience(^) con el texto #Port 22
		# Port 2222 -> El reemplazo
	# /etc/ssh/sshd_config -> EL archivo de configuracion del servidor SSH

echo "Reiniciando servidor SSH..."
sudo systemctl restart ssh

#----------------------
# Configurando Firewall
#----------------------

echo "Configurando Firewall..."
sudo ufw enable
sudo ufw allow 2222/tcp
sudo ufw deny 22/tcp
sudo ufw --force enable
	# --force -> Evita que el script se detenga pidiendo confirmacion interactiva

#--------------------------------
# Final del Script y verificacion
#--------------------------------

echo "Instalacion servidor SSH Finalizada"
sudo systemctl status ssh --no-pager
	# --no-pager -> Evita que la salida se detenga y requiera pulsar Enter

#---------------------------------
# Reinicamos el sistema
#--------------------------------

echo -e -n "\nPulsa cualquier tecla para reiniciaro pulsa (s) para salir del script y no reiniciar:"

read opcion2
case "$opcion2" in
	s | S)
		exit 0
		;;
	*)
		sudo reboot
		;;
esac





