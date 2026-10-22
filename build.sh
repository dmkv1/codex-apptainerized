#!/bin/bash
# Builds codex.sif next to this script. Run as a regular user with /etc/subuid entries.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"
apptainer build --fakeroot --force "$SCRIPT_DIR/codex.sif" "$SCRIPT_DIR/codex.def"
