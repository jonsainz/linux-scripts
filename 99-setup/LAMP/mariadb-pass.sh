#!/bin/bash

# Pedir la nueva contraseña
echo -e "\nEscribe la nueva contraseña para MariaDB (no se verá mientras escribes):"
read -s password

# Aplicar el cambio usando sudo para asegurar el acceso al socket
sudo mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '$password';
FLUSH PRIVILEGES;
EOF

echo -e "\nContraseña actualizada correctamente en MariaDB."
echo "------------------------------------------------"
echo -e "\nProbando acceso con la nueva contraseña:"

# Intento de login automático para verificar
mysql -u root -p"$password" -e "SELECT 'CONEXIÓN EXITOSA' AS Estado;"

echo -e "\nPara entrar en MariaDB monitor ejecuta mariadb.sh\n"
