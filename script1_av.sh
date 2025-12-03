#!/bin/bash

#Name to put in the folder
MY_NAME="AnaMaciel"

#Where the folder will be created
MAIN_DIR="$(pwd)/Project_ibbc_$MY_NAME"

#Create the main Directory
mkdir -p "$MAIN_DIR"

#Create subdirectories
mkdir -p "$MAIN_DIR/raw_data"
mkdir -p "$MAIN_DIR/trims"
mkdir -p "$MAIN_DIR/logs"
mkdir -p  "$MAIN_DIR/results"

echo "Pastas criadas! :)"
