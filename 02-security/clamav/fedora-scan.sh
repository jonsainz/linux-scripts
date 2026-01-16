#!/bin/bash

# Escaneo a mi Fedora sin escanear VM ni carpetas que no ahce falta

sudo freshclam
sudo nice -n 19 clamscan -r -i --verbose \
  --exclude-dir=^/var/lib/libvirt/images \
  --exclude-dir=^/home/$USER/.local/share/gnome-boxes/images \
  --exclude-dir=^/home/$USER/VirtualBox\ VMs \
  --exclude-dir=^/sys \
  --exclude-dir=^/proc \
  --exclude-dir=^/dev \
  /
