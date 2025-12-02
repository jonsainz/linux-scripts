#!/bin/bash
# 03-backup/backup-home.sh
# Hace una copia comprimida del directorio /home

BACKUP_DIR="/backup"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
mkdir -p "$BACKUP_DIR"

echo "Creando backup de /home..."
tar -czf "$BACKUP_DIR/home_$TIMESTAMP.tar.gz" /home

echo "Backup completado: $BACKUP_DIR/home_$TIMESTAMP.tar.gz"
