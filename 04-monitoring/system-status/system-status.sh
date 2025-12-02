#!/bin/bash
# 04-monitoring/system-status.sh
# Muestra estado básico del sistema

echo "=== Uso de CPU ==="
top -b -n1 | head -5

echo "=== Uso de RAM ==="
free -h

echo "=== Procesos principales ==="
ps aux --sort=-%cpu | head -10
