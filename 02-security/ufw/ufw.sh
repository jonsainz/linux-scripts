#!/bin/bash


# Empezar de cero

sudo ufw reset

# Base segura

sudo ufw default deny incoming
sudo ufw default allow outgoing

# Web publica

sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Protege fuerza bruta

sudo ufw limit 2222/tcp

# Tailscale

sudo ufw allow in on tailscale0
sudo ufw allow out on tailscale0

# Uso SSH por Tailscale, asi que cerramos SSH publico

# Activar ufw

sudo ufw delete limit 2222/tcp
sudo ufw allow from 100.64.0.0/10 to any port 2222


sudo ufw enable

# Resultado final

sudo ufw status
