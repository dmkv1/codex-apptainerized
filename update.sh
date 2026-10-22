#!/bin/bash
# Updates Codex in the image: ./update.sh [VERSION|latest] (default: latest).
# Sets CODEX_VERSION in codex.def, rebuilds codex.sif on the existing base.sif and
# installs it. Run as the admin user (asks for sudo) or as root, e.g. from cron.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

want="${1:-latest}"
if [ "$want" = latest ]; then
  want="$(curl -fsSL https://api.github.com/repos/openai/codex/releases/latest \
    | sed -nE 's/.*"tag_name": *"rust-v([^"]+)".*/\1/p')"
  [ -n "$want" ] || { echo "could not determine the latest Codex release" >&2; exit 1; }
fi

current="$(sed -nE 's/^ *CODEX_VERSION=//p' codex.def)"
if [ "$want" = "$current" ] && cmp -s codex.sif /opt/codex/codex.sif 2>/dev/null; then
  echo "Codex $current is already installed"
  exit 0
fi

sed -i -E "s/^( *CODEX_VERSION=).*/\1$want/" codex.def
./build.sh
if [ "$(id -u)" = 0 ]; then ./install.sh; else sudo ./install.sh; fi
echo "Codex $current -> $want installed"
