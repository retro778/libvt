#!/bin/bash
set -euo pipefail

echo "========================================"
echo " libvt build docs"
echo "========================================"
echo

# --- auto-detect fbc ---
FBC=

if command -v fbc >/dev/null 2>&1; then
    FBC=$(command -v fbc)
fi

if [ -z "$FBC" ]; then
    for D in \
        "/usr/local/bin/fbc" \
        "/usr/bin/fbc" \
        "/opt/freebasic/bin/fbc"
    do
        if [ -x "$D" ]; then
            FBC="$D"
            break
        fi
    done
fi

if [ -z "$FBC" ]; then
    echo " ERROR: FreeBASIC compiler not found."
    echo " Please add fbc to your PATH or install FreeBASIC to a standard location."
    echo
    exit 1
fi

echo " Compiler: $FBC"
echo

# --- ensure docs/ exists ---
mkdir -p docs

# --- compile utils ---
echo " [1/3] Compiling utils..."

printf "    apidump  ... "
"$FBC" utils/apidump.bas -x utils/apidump >/dev/null 2>&1 || { echo "FAILED"; exit 1; }
echo "OK"

printf "    vthgen   ... "
"$FBC" utils/vthgen.bas -x utils/vthgen >/dev/null 2>&1 || { echo "FAILED"; exit 1; }
echo "OK"

printf "    vth2html ... "
"$FBC" utils/vth2html.bas -x utils/vth2html >/dev/null 2>&1 || { echo "FAILED"; exit 1; }
echo "OK"

echo

# --- run apidump ---
echo " [2/3] Generating API dump..."
printf "    apidump vt ... "
utils/apidump vt >/dev/null 2>&1 || { echo "FAILED"; exit 1; }
mv -f libvt_api_dump.txt docs/
echo "OK"

echo

# --- run vthgen + vth2html ---
echo " [3/3] Generating docs..."

printf "    vthgen vt vt.vth ... "
utils/vthgen vt vt.vth >/dev/null 2>&1 || { echo "FAILED"; exit 1; }
echo "OK"

# vth2html needs vt.vth in root still, move after
printf "    vth2html vt.vth libvt.html ... "
utils/vth2html vt.vth libvt.html "LibVT API Reference" >/dev/null 2>&1 || { echo "FAILED"; exit 1; }
echo "OK"

# now move both to docs/
mv -f vt.vth docs/
mv -f libvt.html docs/

echo
echo "========================================"
echo " All done! Docs are in docs/"
echo "========================================"
echo
