#!/usr/bin/env bash
# Script de actualización y mantenimiento profesional (Versión Ultimate 2026)
# Soporta: Debian/Ubuntu, Fedora, Flatpak, Snap, Pip, NPM, Yarn.

set -o errexit
set -o nounset
set -o pipefail

# === Configuración ===
DRY_RUN=false
ASSUME_YES=false
LOG_FILE="/var/log/actualizar_sistema.log"
LOCK_FILE="/var/lock/actualizar_sistema.lock"
JOURNAL_MAX="200M"
TMP_CLEAN_AGE_DAYS=7

# === Colores para terminal ===
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# === Ayuda ===
usage() {
  cat <<EOF
Uso: $(basename "$0") [--dry-run] [--yes] [--help]
  --dry-run    Simula las acciones (no requiere root)
  --yes        No pide confirmación (ideal para cron)
EOF
  exit 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=true; shift ;;
    --yes) ASSUME_YES=true; shift ;;
    --help) usage ;;
    *) echo -e "${RED}Opción desconocida: $1${NC}"; usage ;;
  esac
done

# === Inicialización de Logs y Locks ===
if [[ ! -w "$(dirname "$LOG_FILE")" ]]; then LOG_FILE="/tmp/$(basename "$LOG_FILE")"; fi
if [[ ! -w "$(dirname "$LOCK_FILE")" ]]; then LOCK_FILE="/tmp/$(basename "$LOCK_FILE")"; fi

ACTIONS_RUN=0
ACTIONS_FAIL=0
ACTIONS_SKIPPED=0

log() {
  local msg="$*"
  local ts=$(date --iso-8601=seconds 2>/dev/null || date +"%Y-%m-%dT%H:%M:%S")
  printf '%s %s\n' "$ts" "$msg" | tee -a "$LOG_FILE"
}

run() {
  ACTIONS_RUN=$((ACTIONS_RUN + 1))
  if $DRY_RUN; then
    log "${YELLOW}[DRY-RUN]${NC} $*"
    return 0
  fi
  log "${GREEN}[RUN]${NC} $*"
  if "$@"; then
    return 0
  else
    local rc=$?
    ACTIONS_FAIL=$((ACTIONS_FAIL + 1))
    log "${RED}ERROR: comando falló (RC=$rc):${NC} $*"
    return $rc
  fi
}

require_cmd() { command -v "$1" >/dev/null 2>&1; }

confirm_or_exit() {
  if $ASSUME_YES; then return 0; fi
  read -r -p "$1 [y/N]: " reply
  [[ "$reply" =~ ^[Yy]$ ]] || { log "Operación cancelada por usuario."; return 1; }
}

# === Bloqueo de concurrencia ===
exec 200>"$LOCK_FILE"
if ! flock -n 200; then
  log "${RED}Error: Ya hay otra instancia activa ($LOCK_FILE).${NC}"
  exit 1
fi

cleanup() {
  local rc=$?
  # Comprobar si se requiere reinicio (específico Ubuntu/Debian)
  REBOOT_MSG=""
  if [[ -f /var/run/reboot-required ]]; then
    REBOOT_MSG="${RED} [!] REINICIO REQUERIDO [!]${NC}"
  fi

  log "--- Resumen: Ejecutadas=$ACTIONS_RUN Fallidas=$ACTIONS_FAIL Saltadas=$ACTIONS_SKIPPED ---"
  log "Finalizado (RC=$rc).$REBOOT_MSG"
  
  if require_cmd notify-send && [[ -n "${DISPLAY:-}" ]]; then
    notify-send "Mantenimiento Linux" "Finalizado con éxito. Fallos: $ACTIONS_FAIL. $REBOOT_MSG"
  fi
  flock -u 200 2>/dev/null || true
  exit $rc
}
trap cleanup EXIT INT TERM

# === Comprobaciones Previas ===
if [[ $EUID -ne 0 ]] && ! $DRY_RUN; then
  echo -e "${RED}Error: Se requiere sudo/root.${NC}"
  exit 1
fi

log "=== 🚀 Inicio de Mantenimiento ==="

# Comprobar Red (Ping + HTTP de respaldo)
CONNECTED=false
if ping -c1 -w2 8.8.8.8 >/dev/null 2>&1; then
    CONNECTED=true
elif require_cmd curl && curl -Is --connect-timeout 2 http://www.google.com | grep -q "200" >/dev/null 2>&1; then
    CONNECTED=true
fi

if ! $CONNECTED && ! $DRY_RUN; then
    log "${YELLOW}Aviso: Sin conexión a internet detectada. Se omitirán actualizaciones.${NC}"
fi

# === 1) GESTORES DE PAQUETES NATIVOS ===
if $CONNECTED || $DRY_RUN; then
    if require_cmd apt; then
        log "📦 Gestor: APT"
        run apt update
        run apt -y full-upgrade
        run apt -y autoremove
        run apt -y autoclean
    elif require_cmd dnf; then
        log "📦 Gestor: DNF"
        run dnf -y upgrade
        run dnf -y autoremove
        run dnf -y clean all
    fi

    # Snaps y Flatpaks
    if require_cmd snap; then
        log "📦 Snap: Refresh"
        run snap refresh || true
    fi
    if require_cmd flatpak; then
        log "📦 Flatpak: Update"
        run flatpak update -y
        run flatpak uninstall --unused -y
    fi
fi

# === 2) LIMPIEZA PROFUNDA ===
log "🧹 Limpieza de sistema..."

# Temporales antiguos
run find /tmp -mindepth 1 -xdev -mtime +"$TMP_CLEAN_AGE_DAYS" -exec rm -rf {} + || true

# Cache de miniaturas del usuario real
REAL_USER=${SUDO_USER:-$USER}
USER_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6 || echo "/root")

if [[ -d "$USER_HOME/.cache/thumbnails" ]]; then
    log "Limpiando miniaturas de $REAL_USER"
    if $DRY_RUN; then log "[DRY-RUN] rm -rf $USER_HOME/.cache/thumbnails/*"; else
    find "$USER_HOME/.cache/thumbnails" -mindepth 1 -delete || true; fi
fi

# Journalctl
if require_cmd journalctl; then
    run journalctl --vacuum-size="$JOURNAL_MAX"
fi

# Coredumps
if [[ -d /var/lib/systemd/coredump ]]; then
    if $ASSUME_YES || confirm_or_exit "¿Borrar volcados de memoria (coredumps)?"; then
        run rm -rf /var/lib/systemd/coredump/*
    fi
fi

# === 3) OPTIMIZACIÓN Y DESARROLLO ===
if require_cmd updatedb; then run updatedb; fi

if require_cmd fstrim; then
    log "Optimizando SSD..."
    run fstrim -av || true
fi

# Limpieza de lenguajes de programación
if require_cmd pip; then run pip cache purge || true; fi
if require_cmd pip3; then run pip3 cache purge || true; fi
if require_cmd npm; then run npm cache clean --force || true; fi

# === 4) REVISIÓN DE ESTADO ===
if require_cmd systemd-analyze; then
    echo -e "\n${YELLOW}Estadísticas de arranque:${NC}"
    systemd-analyze || true
fi

log "✅ Proceso completado."
