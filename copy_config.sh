
#!/bin/bash
# This script moves the config.yaml to the /app directory inside the container

CONFIG_SOURCE="/bifrost-hassio/config.yaml"
CONFIG_DEST="/app/config.yaml"  # Destination inside the container

# Copy the config file to the destination
cp $CONFIG_SOURCE $CONFIG_DEST

echo "Config file copied to $CONFIG_DEST"
