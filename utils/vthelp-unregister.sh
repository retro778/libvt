#!/bin/bash
# Remove .vth file association for vthelp  (user-level, no root required)
set -euo pipefail

MIME_FILE="$HOME/.local/share/mime/packages/vthelp.xml"
DESKTOP_FILE="$HOME/.local/share/applications/vthelp.desktop"

if [ -f "$MIME_FILE" ]; then
    rm "$MIME_FILE"
    update-mime-database "$HOME/.local/share/mime"
fi

if [ -f "$DESKTOP_FILE" ]; then
    rm "$DESKTOP_FILE"
    update-desktop-database "$HOME/.local/share/applications"
fi

echo ".vth file association removed"
