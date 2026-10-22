#!/bin/bash
# Installs codex.sif to /opt/codex (readable by the lab group) and the
# launcher to /usr/local/bin/codex. Run with sudo after build.sh.
set -euo pipefail

[ "$(id -u)" = 0 ] || { echo "run with sudo" >&2; exit 1; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GROUP="${CODEX_GROUP:-lab-pk}"

install -d -m 750 -o root -g "$GROUP" /opt/codex
# Copy then rename so running sessions keep their image
install -m 640 -o root -g "$GROUP" "$SCRIPT_DIR/codex.sif" /opt/codex/codex.sif.new
mv -f /opt/codex/codex.sif.new /opt/codex/codex.sif
install -m 755 -o root -g root "$SCRIPT_DIR/codex" /usr/local/bin/codex

echo "Installed /opt/codex/codex.sif and /usr/local/bin/codex for group $GROUP"
