# Proyecto Servidor SSH

Este proyecto instala el servidor **SSH OpenSSH Server** e Instala el Firewall **ufw**.
Despues cambia al puerto por defecto, que es el **puerto 22** por el **puerto 2222**, menos comun y asi evitamos ataques automaticos.
Tambien configura el Firewall para permitir la entrada en ese puerto.

---

## Caracteristicas

- Te obliga a instalar el script como super usuario.
- Instala el servidor OpenSSH (si no esta instalado).
- Cambia el puerto por defecto **22** por el puerto **2222**.
- Cierra el puerto ** 22**.
- Habilita y configura el firewall **ufw**.
- Abre el puerto **2222** en el firewall.
- Reinicia el servidor SSH para activar cambios.
- El usuario no necesita interactuar.
- Reinicia automaticamente el sistema.

---

# Requisitos

- Sistema operativo basado en Linux (Que use apt como Ubuntu...).
- Permisos de Superusuario.
- Conexion a internet para instalar paquetes.

---

## Uso

1. Clona el repositorio

	bash
	gitclone https://github.com/......git

2. Ejecuta el script

	bash
	./instalar_ssh.sh

---



