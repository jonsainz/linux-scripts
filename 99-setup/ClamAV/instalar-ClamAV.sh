#!/bin/bash

sudo apt update -y

#Instalamos ClamAV y clamav-deamon porque ayuda a que sea mas rapido
sudo apt install clamav -y && sudo apt install clamav-deamon -y

# Actualizarlo
sudo systemctl stop clamav-freshclam
sudo freshclam
sudo systemctl start clamav-freshclam




