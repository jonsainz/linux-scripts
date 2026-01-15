# Vm en Virtualbox Aislada


- Crear en VirtualBox una Red NAT.
Reglas de la Red NAT:

* Sacar fotos configuracion y ver si esta bien y escribirlas aqui

 
- Dentro de la configuracion de la Vm:
Configurar la VM con Red Nat y las Reglas creadas

Desactivar: Carpetas compartidas / Pegar Portapapeles / Arrastrar y soltas


Las reglas son basicamente. abro el puerto 443 del router y creo una regla en el router:
todo lo que llegue al 443 envialo a la IP de mi fedora al puerto 8443
en fedora abrir firewall el 8443
virtualbox recibe ese 8443 y lo traduce al 443 de la IOP interna de la VM
UBUNTU PROCESA Y ENTREA LA WEB

comprobacion de que la web funciona: ping tu-subdominio.duckdns.org
deberia de scar la IP de duckdns

## Comprobaciones

- Actualizar sistema
- Instalar nmap: sudo apt install nmap -y

nmap -Pn 10.0.2.2
Deberia decir: All 1000 scanned ports are filtered o Host seems donw

si sale: 22/tcp open o 139/tcp open, podrian entrar

- ping -c 10.0.2.2
Si no responde OK

Si responde y hay puertos abiertos con nmap

- Bloquear acceso al Host (Desde Fedora)

# Bloquea todo lo que venga de la VM hacia tu PC
sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="10.0.2.0/24" reject'
sudo firewall-cmd --reload


- Instala LAMP para comprobaciones

Consigue que se vea la web. EN fEDORA	

http://localhost
https://localhost:8443

en Fedora:

curl -kI https://localhost:8443

si sale: HTTP/1.1 200 OK
Esta bien aislado



### Resumen

Para que este Aislado:

- Ping falla
- Nmap muestra "Filtered"
- Localhost:8443 funciona
