#!/bin/bash
# 02-security/security-check.sh
# Revisa actualizaciones de seguridad y estado del firewall

echo "Comprobando actualizaciones de seguridad..."
apt update -qq
apt list --upgradable 2>/dev/null | grep -i security || echo "No hay actualizaciones de seguridad pendientes."

echo "Estado del firewall (ufw)..."
ufw status verbose || echo "ufw no instalado"

echo "Chequeo de seguridad completado."
