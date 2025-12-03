#!/usr/bin/env bash
set -euo pipefail

# Variables
MY_NAME="AnaMaciel"
MAIN_DIR="$(pwd)/Project_ibbc_$MY_NAME"

# Create the archive inside MAIN_DIR
echo "[INFO] Compressing results..."
tar -czf "$MAIN_DIR/${MY_NAME}_results.tar.gz" \
    "$MAIN_DIR/results" \
    "$MAIN_DIR/logs"
echo "[INFO] Done!"

