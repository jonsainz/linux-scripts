#!/bin/bash

#---------------------------------------#
# Script de Mantenimiento Fedora/Debian #
#---------------------------------------#

if [[ $EUID -ne 0 ]]; then
    echo -e "\nPara este mantenimiento hacen falta permisos de Root.\n"
    echo -e "Escribe: sudo $0 para ejecutarlo\n"
    exit 1
fi 

echo -e "\n------------------------------------"
echo -e "Iniciando Mantenimiento Completo..."
echo -e "------------------------------------\n"

# 1. OPTIMIZACIÓN DE HARDWARE (Vital para tu SSD)
echo -e "1/5 -> Optimizando celdas del SSD..."
sudo fstrim -av

# 2. ACTUALIZACIÓN DE SISTEMA Y DRIVERS (Incluye tu NVIDIA)
echo -e "\n2/5 -> Buscando actualizaciones (Sistema y NVIDIA)..."
# Intentar primero DNF (Fedora) y si falla APT (Debian/Ubuntu)
if command -v dnf &> /dev/null; then
    sudo dnf upgrade --refresh -y
else
    sudo apt update && sudo apt upgrade -y
fi

# 3. LIMPIEZA DE CACHÉ Y BASURA
echo -e "\n3/5 -> Limpiando archivos temporales y caché..."
if command -v dnf &> /dev/null; then
    sudo dnf clean all
    sudo dnf autoremove -y
else
    sudo apt autoclean -y && sudo apt autoremove --purge -y
fi

# Limpieza manual de archivos pesados
sudo rm -rf /var/tmp/* 2>/dev/null
sudo rm -rf ~/.cache/thumbnails/* 2>/dev/null
sudo rm -rf /var/lib/systemd/coredump/* 2>/dev/null

# 4. LIMPIEZA DE LOGS (Aquí estaba el error: era vacuum con 'u' y doble 'm')
echo -e "\n4/5 -> Reduciendo tamaño de los Logs del sistema..."
# Esto limita los registros de errores a 200MB para que no pesen
sudo journalctl --vacuum-size=200M

# 5. ACTUALIZAR BUSCADOR DE ARCHIVOS (Lo que bloqueamos en el arranque)
echo -e "\n5/5 -> Indexando archivos para el buscador (plocate)..."
sudo updatedb

echo -e "\n------------------------------------"
echo -e "¡Mantenimiento completado con éxito!"
echo -e "------------------------------------\n"

# Extra: Ver el tiempo de arranque actual
echo -e "Tu tiempo de arranque actual es:"
systemd-analyze
