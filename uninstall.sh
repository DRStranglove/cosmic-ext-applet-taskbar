#!/usr/bin/env bash
# Remove the COSMIC Taskbar applet from the current user's directories.
set -euo pipefail

BIN_NAME="cosmic-ext-applet-taskbar"
DESKTOP="com.cosmicext.Taskbar.desktop"

rm -fv "${HOME}/.local/bin/${BIN_NAME}"
rm -fv "${HOME}/.local/share/applications/${DESKTOP}"

command -v update-desktop-database >/dev/null 2>&1 && \
    update-desktop-database "${HOME}/.local/share/applications" >/dev/null 2>&1 || true

echo
echo "Removed. Also remove it from your bar in Settings -> Desktop -> Panel/Dock -> Configure applets."
