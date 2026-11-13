#!/bin/bash
# Associate .vth files with vthelp  (user-level, no root required)
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
VTHELP="$SCRIPT_DIR/vthelp"

if [ ! -x "$VTHELP" ]; then
    echo "ERROR: vthelp binary not found at $VTHELP"
    echo "Please compile vthelp first."
    exit 1
fi

MIME_DIR="$HOME/.local/share/mime/packages"
APPS_DIR="$HOME/.local/share/applications"

mkdir -p "$MIME_DIR" "$APPS_DIR"

# --- MIME type definition ---
cat > "$MIME_DIR/vthelp.xml" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
  <mime-type type="application/x-vthelp">
    <comment>VTHelp file</comment>
    <glob pattern="*.vth"/>
  </mime-type>
</mime-info>
EOF

update-mime-database "$HOME/.local/share/mime"

# --- desktop entry ---
cat > "$APPS_DIR/vthelp.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=VTHelp
Comment=VTHelp file viewer
Exec=$VTHELP %f
MimeType=application/x-vthelp;
Terminal=false
Categories=Utility;
EOF

update-desktop-database "$APPS_DIR"
xdg-mime default vthelp.desktop application/x-vthelp

echo ".vth files are now associated with vthelp"
echo "Location: $VTHELP"
