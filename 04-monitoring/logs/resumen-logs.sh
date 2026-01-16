#!/bin/bash

LOG_DIR="$(dirname "$(realpath "$0")")"

echo "===== RESUMEN LEGIBLE DE LOGS ====="
echo "Fecha: $(date)"
echo "Carpeta de logs: $LOG_DIR"
echo

# ----------------------
# Apache access.log
# ----------------------
if [ -f "$LOG_DIR/access_siz.log" ]; then
    echo ">> Apache access.log: últimos 5 accesos"
    tail -n 5 "$LOG_DIR/access_siz.log" | awk '{print "IP="$1", Método="$6", Recurso="$7", Código="$9}'
    echo
fi

# ----------------------
# Apache error.log
# ----------------------
if [ -f "$LOG_DIR/error_siz.log" ]; then
    echo ">> Apache error.log: últimos 5 errores"
    tail -n 5 "$LOG_DIR/error_siz.log" | awk '{print "["$1" "$2" "$3"] Tipo="$4", Mensaje="$0}'
    echo
fi

# ----------------------
# SSH (auth.log)
# ----------------------
if [ -f "$LOG_DIR/auth.log" ]; then
    echo ">> SSH auth.log: últimos 5 intentos fallidos"
    grep -i "failed" "$LOG_DIR/auth.log" | tail -5 | awk '{print "Hora="$1" "$2", IP="$11", Usuario="$9}'
    echo
    echo ">> SSH auth.log: últimos 5 logins correctos"
    grep -i "accepted" "$LOG_DIR/auth.log" | tail -5 | awk '{print "Hora="$1" "$2", IP="$11", Usuario="$9}'
    echo
fi

# ----------------------
# UFW
# ----------------------
if [ -f "$LOG_DIR/ufw.log" ]; then
    echo ">> UFW.log: últimos 5 bloqueos"
    grep -i "BLOCK" "$LOG_DIR/ufw.log" | tail -5 | awk '{print "Hora="$1" "$2", IP="$9", Puerto="$11}'
    echo
fi

# ----------------------
# Fail2Ban
# ----------------------
if [ -f "$LOG_DIR/fail2ban.log" ]; then
    echo ">> Fail2Ban.log: últimos 5 bans"
    grep -i "Ban" "$LOG_DIR/fail2ban.log" | tail -5 | awk '{print "Hora="$1" "$2", IP="$NF}'
    echo
fi

echo "===== FIN DEL RESUMEN ====="
