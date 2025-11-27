#!/bin/bash

#--------------------#
# Actualizar sistema #
#--------------------#


echo -e "\n-----------------------\nActualizando sistema...\n-----------------------\n"


# Actualizar para distribuciones basadas en Debian o RedHat.
# Probado en Ubuntu-server y Fedora.

sudo apt update -y 2>/dev/null || sudo dnf update -y
sudo apt upgrade -y 2>/dev/null || sudo dnf upgrade -y


echo -e "\nActualizacion realizada.\n"

