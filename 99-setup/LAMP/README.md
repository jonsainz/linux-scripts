# LAMP

Script para la instalacion de LAMP (Linux+Apache2+MariaDB+PHP).

- Instala Apache2 y configura y crea una web
- Instala y configura MariaDB con una contraseña: 123456 (Hay un script para cambiar la contraseña)
- Instala PHP y crea un archivo info.php de prueba


## Intrucciones


1) instala LAMP

- Usar instalador install-lamp.sh

2) Cambia contraseña MariaDB

- Usar script mariadb-pass.sh

3) Abre el navegador y prueba que todo este bien

- Saber IP del oprdenador: <br>
    <br>hostname -I

- Abrir navegador dos ventanas:<br>
    <br>http://IP <br>
    http://IP/info.php

4) Si quieres configurar MariaDB hay un script para ejecutarlo
    <br>mariadb.sh
### Consideraciones

Hay que tener en cuenta que antes de publicar nuestra web el archivo info.php hay que borrarlo.
Esta bien tenerlo mientras creamos la web.
