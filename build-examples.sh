#!/bin/bash
set -uo pipefail

echo "========================================"
echo " libvt test suite - build examples"
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

# --- compile examples ---
EXAMPLES_DIR=examples
PASS=0
FAIL=0
FAILED_LIST=()

for F in "$EXAMPLES_DIR"/*.bas; do
    FILENAME=$(basename "$F")
    printf "  Compiling %s ... " "$FILENAME"
    if "$FBC" "$F" >/dev/null 2>&1; then
        echo "OK"
        PASS=$((PASS + 1))
    else
        echo "FAILED"
        FAIL=$((FAIL + 1))
        FAILED_LIST+=("$FILENAME")
    fi
done

echo
echo "========================================"
echo " Results: $PASS passed,  $FAIL failed"
echo "========================================"

if [ "$FAIL" -gt 0 ]; then
    echo
    echo " Failed files:"
    for X in "${FAILED_LIST[@]}"; do
        echo "   - $X"
    done
    echo
    exit 1
fi

echo
