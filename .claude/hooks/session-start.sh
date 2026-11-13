#!/bin/bash
set -euo pipefail

# Only run in remote (cloud) environments
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
    exit 0
fi

FBC_VERSION="1.10.1"
FBC_TARBALL="FreeBASIC-${FBC_VERSION}-linux-x86_64.tar.gz"
FBC_URL="http://downloads.sourceforge.net/fbc/${FBC_TARBALL}?download"
FBC_TMP="/tmp/fbc-install"

# Install FreeBASIC if not already present
if ! command -v fbc &>/dev/null; then
    echo "Installing FreeBASIC ${FBC_VERSION}..."

    # libtinfo.so.5 is required by the fbc binary
    wget -q "http://archive.ubuntu.com/ubuntu/pool/universe/n/ncurses/libtinfo5_6.3-2ubuntu0.1_amd64.deb" \
         -O /tmp/libtinfo5.deb
    dpkg -i /tmp/libtinfo5.deb

    # SDL2 is required to link vtsolitaire and other SDL2-backed examples
    apt-get install -y libsdl2-dev

    # Download and install FreeBASIC
    mkdir -p "$FBC_TMP"
    wget -q -L "$FBC_URL" -O "$FBC_TMP/$FBC_TARBALL"
    tar -xzf "$FBC_TMP/$FBC_TARBALL" -C "$FBC_TMP"
    cd "$FBC_TMP/FreeBASIC-${FBC_VERSION}-linux-x86_64"
    ./install.sh -i /usr/local

    echo "FreeBASIC installed: $(fbc -version)"
fi

# Test-compile vtsolitaire.bas to verify the environment (TUI + SDL2 path)
echo "Test-compiling examples/vtsolitaire.bas..."
fbc "${CLAUDE_PROJECT_DIR}/examples/vtsolitaire.bas" -o /tmp/vtsolitaire-test
rm -f /tmp/vtsolitaire-test
echo "Test compile OK."
