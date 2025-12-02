#!/bin/bash
# 99-setup/basic-packages.sh
# Instala paquetes básicos

echo "Actualizando repositorios..."
apt update -y

echo "Instalando paquetes: curl, git, vim..."
apt install -y curl git vim nano 

echo "Instalación completada."
