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

	echo -e "\nPara ejecutar este script que instalala el servidor SSH y sus configuraciones hace falta ejecutarlo como Root\n"
	exit 1
	# exit 1 -> Termina el script
fi

#-----------------------------
# Pregunta si quiere continuar
#-----------------------------

echo -e "\nAtencion: Este script reiniciara el sistema despues de acabar la instalacion\n"
echo -n -e "\nDesea continuar? (s/n): "

read opcion
case "$opcion" in
	s | S)
		echo -e "\nContinuando con la instalacion...\n"
		;;
	n | N)
		echo -e "\nSaliendo del script de instalacion...\n"
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

echo -e "\nActualizando paquetes...\n"
sudo apt update -y
sudo apt upgrade -y

#-----------------------
# Instalar SSH y Firewall
#------------------------

echo -e "\nInstalando servidor SSH...\n"
sudo apt install openssh-server -y
echo -e "\nInstalando Firewall...\n"
sudo apt install ufw -y

#---------------------
# Iniciar Servidor SSH
#---------------------

echo -e "\nIniciando Servidor SSH\n"

sudo systemctl start ssh
sudo systemctl enable ssh

#--------------------------------------------------------
# Cambiando puerto por defecto 22 a 2222 del servidor SSH
#--------------------------------------------------------

echo -e "\nCambiando puerto del SSH a 2222...\n
# sed -> Comando para editar textos

sudo sed -i 's/^#Port 22/Port 2222/' /etc/ssh/sshd_config

	# -i -> Inplace: Cambios directamente en el archivo
	# 's/PATRON/REEMMPLAZO'
		# ^#Port 22 -> Busca una linea que comience(^) con el texto #Port 22
		# Port 2222 -> El reemplazo
	# /etc/ssh/sshd_config -> EL archivo de configuracion del servidor SSH

echo -e "\nReiniciando servidor SSH...\n"

sudo systemctl restart ssh

#----------------------
# Configurando Firewall
#----------------------

echo -e "\nConfigurando Firewall...\n"
sudo ufw enable
sudo ufw allow 2222/tcp
sudo ufw deny 22/tcp
sudo ufw --force enable
	# --force -> Evita que el script se detenga pidiendo confirmacion interactiva

#--------------------------------
# Final del Script y verificacion
#--------------------------------

echo -e "\nInstalacion servidor SSH Finalizada\n"
sudo systemctl status ssh --no-pager
	# --no-pager -> Evita que la salida se detenga y requiera pulsar Enter

#---------------------------------
# Reinicamos el sistema
#--------------------------------
echo -e "\nSe puede ver que esta escuchando el Puerto 22, pero al reiniciar escuchara al Puerto 2222\n"

echo -e -n "\nQuiere reiniciar? (s/n):  "

read opcion2
case "$opcion2" in
	s | S)
		sudo reboot
		;;
	n | N)
		exit 0
		;;
	*)
		echo -e "\nError al introducir respuesta. Saliendo del script...\n"
		exit 1
		;;
esac





