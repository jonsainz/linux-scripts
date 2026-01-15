#!/bin/bash

if [ "$EUID" -ne 0 ]; then 
  echo "Por favor, ejecuta este script usando sudo o como root"
  exit
fi

# 1. Cambiar la configuración a español (es) en el archivo de sistema
# Usamos 'sed' para buscar la línea XKBLAYOUT y reemplazarla
sudo sed -i 's/XKBLAYOUT="us"/XKBLAYOUT="es"/' /etc/default/keyboard

# 2. Aplicar los cambios inmediatamente para la sesión actual
udevadm trigger --subsystem-match=input --action=change
sudo setupcon

echo "Teclado configurado en español."


