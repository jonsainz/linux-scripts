#!/bin/bash

#--------------------#
# Actualizar sistema #
#--------------------#

if [[ $EUID -ne 0 ]]; then

	echo -e "\nPara instalar hace falta permisos de Root.\n"
	echo -e "\nEscribe: sudo ./actualizar.sh para ejecutar la instalación\n"
	exit 1
fi 



echo -e "\n-----------------------\nActualizando sistema...\n-----------------------\n"


# Actualizar para distribuciones basadas en Debian o RedHat.
# Probado en Ubuntu-server y Fedora.

sudo apt update -y 2>/dev/null || sudo dnf update -y
sudo apt full-upgrade -y 2>/dev/null || sudo dnf upgrade -y


echo -e "\nActualizacion realizada.\n"

#---------------------
# Limpieza de archivos
#---------------------



echo -e "\nLimpieza de archivos...\n"

sudo apt autoclean -y 2>/dev/null || sudo dnf clean all -y
sudo apt clean -y 2>/dev/null || sudo dnf autoremove -y
sudo apt autoremove --purge -y 2>/dev/null || sudo systemd-tmpfiles --clean 

echo -e "\nLimpieza lista\n"

# Archivos temporales
sudo rm -rf /temp/* 2>/dev/null
sudo rm -rf /var/temp/* 2>/dev/null

# Archivos de cache
sudo rm -rf ~/.cache 2>/dev/null
sudo rm -rf /var/cache/* 2>/dev/null

# Archiovs de Thumbnails
sudo rm -rf ~/.cache/thumbnails/* 2>/dev/null

# Archivos de logs

#Esto da error. que es?
#sudo journalctl --vacumm-size=200M

# Archivos de Coredumps
sudo rm -rf /var/lib/systemd/coredump/* 2>/dev/null


