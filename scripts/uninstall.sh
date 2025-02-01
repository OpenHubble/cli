#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root (use sudo)"
  exit 1
fi

# Remove directories
echo "Removing cli files..."
rm -rf /opt/openhubble-cli
rm -rf /etc/openhubble-cli
rm -rf /var/log/openhubble-cli

# Remove the symbolic link for openhubble-cli
echo "Removing symbolic link..."
rm -f /usr/local/bin/openhubble-cli

echo "OpenHubble CLI has been uninstalled successfully."
