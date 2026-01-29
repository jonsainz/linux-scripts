#!/usr/bin/env bash
# Script de actualización y mantenimiento profesional
# Soporta: Fedora (DNF), Ubuntu/Debian (APT) y Flatpak

set -o errexit
set -o nounset
set -o pipefail

DRY_RUN=false
ASSUME_YES=false

usage() {
  cat <<EOF
Uso: $(basename "$0") [--dry-run] [--yes] [--help]
  --dry-run    muestra las acciones sin ejecutarlas
  --yes        no pide confirmación (modo no interactivo)
EOF
  exit 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=true; shift ;;
    --yes) ASSUME_YES=true; shift ;;
    --help) usage ;;
    *) echo "Opción desconocida: $1"; usage ;;
  esac
done

run() {
  if $DRY_RUN; then
    echo -e "\033[1;33m[DRY-RUN]\033[0m $*"
  else
    echo -e "\033[1;32m[RUN]\033[0m $*"
    "$@"
  fi
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1
}

confirm_or_exit() {
  if $ASSUME_YES; then return 0; fi
  read -r -p "$1 [y/N]: " reply
  [[ "$reply" =~ ^[Yy]$ ]] || { echo "Operación cancelada."; return 1; }
}

if [[ $EUID -ne 0 ]]; then
  echo "Error: Este script debe ejecutarse con sudo."
  exit 1
fi

# Detectar el usuario real detrás de sudo
REAL_USER=${SUDO_USER:-$USER}
USER_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)

echo -e "\n--- 🚀 Inicio: Actualización de Sistema ---\n"

# 1. GESTORES DE PAQUETES NATIVOS
if require_cmd apt-get; then
    echo "📦 Detectado: APT (Debian/Ubuntu)"
    run apt-get update
    run apt-get -y full-upgrade
    run apt-get -y autoremove
    run apt-get -y autoclean
elif require_cmd dnf; then
    echo "📦 Detectado: DNF (Fedora)"
    run dnf -y upgrade
    run dnf -y autoremove
    run dnf -y clean all
elif require_cmd yum; then
    echo "📦 Detectado: YUM"
    run yum -y update
    run yum -y autoremove
    run yum -y clean all
fi

# 2. FLATPAK (Si está instalado)
if require_cmd flatpak; then
    echo -e "\n📦 Actualizando Flatpaks..."
    run flatpak update -y
    run flatpak uninstall --unused -y
fi

echo -e "\n--- 🧹 Limpieza y Mantenimiento ---\n"

# Limpieza de /tmp (archivos de más de 7 días)
echo "Limpiando /tmp (archivos antiguos)..."
if $DRY_RUN; then
    echo "[DRY-RUN] find /tmp -mindepth 1 -mtime +7 -delete"
else
    find /tmp -mindepth 1 -mtime +7 -exec rm -rf {} + || true
fi

# Limpieza de caché de miniaturas del usuario real
if [[ -d "$USER_HOME/.cache/thumbnails" ]]; then
    echo "Limpiando miniaturas de cache de $REAL_USER..."
    run rm -rf "$USER_HOME/.cache/thumbnails/*" 2>/dev/null || true
fi

# Journalctl (Logs del sistema)
if require_cmd journalctl; then
    echo "Reduciendo logs del sistema a 200M..."
    run journalctl --vacuum-size=200M
fi

# Coredumps
if [[ -d /var/lib/systemd/coredump ]]; then
    if $ASSUME_YES || confirm_or_exit "¿Eliminar archivos de error (coredumps)?"; then
        run rm -rf /var/lib/systemd/coredump/*
    fi
fi

# Actualizar base de datos de búsqueda rápida
if require_cmd updatedb; then
    echo "Actualizando base de datos de archivos (updatedb)..."
    run updatedb
fi

# 3. OPTIMIZACIÓN DE DISCO (SSD)
if require_cmd fstrim; then
    echo "Optimizando celdas SSD (fstrim)..."
    run fstrim -av || echo "Aviso: fstrim no pudo completarse (normal en algunas configuraciones)."
fi

# Resumen de tiempo de arranque
if require_cmd systemd-analyze; then
    echo -e "\n--- ⏱️ Tiempo de arranque actual ---"
    systemd-analyze
fi

echo -e "\n✅ Mantenimiento finalizado con éxito.\n"
