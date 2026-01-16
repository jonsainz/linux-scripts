# Vm en Virtualbox Aislada


- Configura modo puente en Virtual box

- Firewall en fedora solo SSH puerto 2222 con claves ssh
- firewall en la VM

sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 22/tcp  # Solo si vas a usar SSH desde Fedora
sudo ufw enable

## Configuracion ROUTER:

- Crear una Red de invitados o VLAN
- Conectas la tarjeta de la red de la VM a esa red aislada:

La forma más robusta de aislar la VM es que Fedora y Ubuntu usen interfaces físicas distintas. Si tu PC tiene una tarjeta Wi-Fi y una de red (Ethernet), puedes hacer lo siguiente:
1. Conecta tu Fedora a tu red normal (vía Wi-Fi, por ejemplo).
2. Conecta un cable Ethernet desde tu PC a un puerto del router que esté configurado como Red de Invitados o VLAN de invitados.
3. En VirtualBox, ve a Red > Adaptador Puente y en "Nombre", selecciona la tarjeta Ethernet.
• Resultado: Ubuntu saldrá por el cable a la red de invitados, mientras Fedora sigue en la red principal por Wi-Fi. No habrá comunicación entre ellas a nivel de router. 
