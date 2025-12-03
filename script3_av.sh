#!/usr/bin/env bash
set -euo pipefail

# Variables
MY_NAME="AnaMaciel"
MAIN_DIR="$(pwd)/Project_ibbc_$MY_NAME"

# Create the archive inside MAIN_DIR
echo "[INFO] Compressing results..."
zip -r "${MAIN_DIR}/${MY_NAME}_results.zip" "$MAIN_DIR/results" "$MAIN_DIR/logs"
echo "[INFO] Done!"

