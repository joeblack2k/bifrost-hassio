#!/bin/bash
# This script copies the config.yaml to the /app directory inside the container

CONFIG_SOURCE="/bifrost-hassio/config.yaml"
CONFIG_DEST="/app/config.yaml"

# Check if source file exists
if [ ! -f "$CONFIG_SOURCE" ]; then
    echo "Error: Config file not found at $CONFIG_SOURCE"
    exit 1
fi

# Copy the config file to the destination
if cp "$CONFIG_SOURCE" "$CONFIG_DEST"; then
    echo "Config file successfully copied to $CONFIG_DEST"
else
    echo "Error: Failed to copy config file"
    exit 1
fi