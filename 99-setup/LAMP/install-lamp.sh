#!/bin/bash

# Script para instalar LAMP en Ubuntu Server

# Comprobar si se ejecuta como root
if [ "$EUID" -ne 0 ]; then
  echo -e "\nPor favor ejecuta como root o con sudo\n"
  exit 1
fi

if [[ $EUID -ne 0 ]]; then

        echo -e "\nPara ejecutar ese script de instalacion, hace falta tener permisos de Root.\n"
        echo -e "\nEscribe: sudo ./apache2.sh\n"
        exit 1
fi

# Actualizamos el sistema

echo -e "\n--------------------\nActualizando sistema\n--------------------\n"

sudo apt update -y && sudo apt upgrade -y

echo -e "\n"
read -p "Pulsa ENTER para continuar..."
echo -e "\n"

# Instalamos apache2

echo -e "\n-----------------\nInstalando Apache\n-----------------\n"

sudo apt install apache2 -y

echo -e "\n"
read -p "Pulsa ENTER para continuar..."
echo -e "\n"

echo -e "\n------------------------\nConfigurando el firewall\n------------------------\n"

sudo ufw allow 'apache' || sudo ufw allow 80/tcp
sudo ufw reload
sudo ufw status

echo -e "\n"
read -p "Pulsa ENTER para continuar..."
echo -e "\n"


echo -e "\n----------------------------------\nPreparando configuracion de Apache\n----------------------------------\n"

sudo cp -r -v config/web.conf /etc/apache2/sites-available/

echo -e "\n"
read -p "Pulsa ENTER para continuar..."
echo -e "\n"

#Creando pagina web basica
echo -e "\n-------------------------\nCreando pagina web basica\n-------------------------\n"

sudo mkdir -v /var/www/web/
sudo mkdir -v /var/www/web/html

echo -e "\n"

sudo cp -r -v config/index.html /var/www/web/html

echo -e "\n"
read -p "Pulsa ENTER para continuar..."
echo -e "\n"

echo -e "\n-----------------------\nConfigurando pagina web\n-----------------------\n"

sudo chmod -R -v 755 /var/www/web/
sudo chown -R -v www-data:www-data /var/www/web/

echo -e "\n"

sudo a2ensite web.conf
sudo a2dissite 000-default.conf
echo -e "\n"
read -p "Pulsa ENTER para continuar..."
echo -e "\n"

echo -e "\n-------------------------------\nTest de configuracion de apache\n-------------------------------\n"
sudo apachectl configtest

echo -e "\n"
read -p "Pulsa ENTER para continuar..."
echo -e "\n"

sudo systemctl restart apache2


# Instalando MariaDB. Es un Mysql gratuito que funciona igual.

echo -e "\n------------------\nInstalando MariaDB\n------------------\n"
apt install mariadb-server mariadb-client -y
systemctl enable mariadb
systemctl start mariadb

echo -e "\n"
read -p "Pulsa ENTER para continuar"
echo -e "\n"

echo -e "\n---------------------------\nSeguridad básica de MariaDB\n---------------------------\n"
mysql_secure_installation <<EOF

y
123456
123456
y
y
y
y
EOF

echo -e "\n------------------------------------------------------\n"
echo -e "\nLa contraseña de MariaDB se a establecido como: 123456\n"
echo -e "\nCambia la contraseña despues de la instalacion con el script 'config/mariadb-pass.sh\n"

echo -e "\n"
read -p "Pulsa ENTER para continuar"
echo -e "\n"

echo -e "\n--------------------------------\nInstalando PHP y módulos comunes\n--------------------------------\n"
apt install php php-mysql libapache2-mod-php php-cli php-curl php-gd php-mbstring php-xml php-zip -y

echo -e "\n"
read -p "Pulsa ENTER para continuar"
echo -e "\n"

echo -e "\nReiniciando Apache para aplicar cambios\n"
systemctl restart apache2

echo -e "\nCreando pagina index.php e info.php\n"
sudo cp -r -v config/info.php /var/www/web/html
sudo mv -v config/index.html /var/www/web/html/index.php


echo -e "\nLAMP instalado correctamente!\n"
hostname -I
echo -e "\nPuedes comprobar tu web: http://IP y tu php: http://IP/info.php"
echo -e "No olvides ejecutar el script config/mariadb-pass.sh para cambiar la contraseña. por defecto: 123456"
