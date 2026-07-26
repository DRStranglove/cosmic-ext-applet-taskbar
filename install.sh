#!/usr/bin/env bash
# Build and install the COSMIC Taskbar applet into the current user's
# directories (no root required).
set -euo pipefail

BIN_NAME="cosmic-ext-applet-taskbar"
DESKTOP="com.cosmicext.Taskbar.desktop"

BIN_DIR="${HOME}/.local/bin"
APP_DIR="${HOME}/.local/share/applications"

root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$root"

echo ">> Building (release) — the first build compiles libcosmic and can take 10-15 min..."
cargo build --release

mkdir -p "$BIN_DIR" "$APP_DIR"

echo ">> Installing binary  -> $BIN_DIR/$BIN_NAME"
install -m755 "target/release/$BIN_NAME" "$BIN_DIR/$BIN_NAME"

echo ">> Installing desktop -> $APP_DIR/$DESKTOP"
# Rewrite Exec to an absolute path so the panel host always finds the binary,
# regardless of whether ~/.local/bin is on PATH in the COSMIC session.
sed "s|^Exec=${BIN_NAME}|Exec=${BIN_DIR}/${BIN_NAME}|" \
    "data/${DESKTOP}" > "$APP_DIR/${DESKTOP}"

command -v update-desktop-database >/dev/null 2>&1 && \
    update-desktop-database "$APP_DIR" >/dev/null 2>&1 || true

case ":$PATH:" in
  *":$BIN_DIR:"*) : ;;
  *) echo ">> Note: $BIN_DIR is not on your PATH (that's fine — the desktop file uses an absolute path)." ;;
esac

cat <<EOF

Done. Now add it to a bar:
  Settings -> Desktop -> Panel (or Dock) -> Configure applets -> + Add -> "Taskbar"
Then remove the stock "App Tray" from that same bar.
If "Taskbar" isn't listed, close and reopen Settings.

Upgrading an existing install? Restart the panel to pick up the new binary:
  kill "\$(pgrep -x cosmic-panel)"
EOF
