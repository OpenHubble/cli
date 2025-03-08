#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root (use sudo)"
  exit 1
fi

set -e  # Stop script on error

INSTALL_DIR="/opt/openhubble-cli"

# Check if the CLI is installed
if [ -d "$INSTALL_DIR" ]; then
  echo "Removing OpenHubble CLI files..."
  rm -rf "$INSTALL_DIR"
else
  echo "OpenHubble CLI is not installed."
fi

# Remove config and logs (if they exist)
rm -rf /etc/openhubble-cli /var/log/openhubble-cli

# Remove the symbolic link
if [ -L "/usr/local/bin/openhubble-cli" ]; then
  echo "Removing symbolic link..."
  rm -f /usr/local/bin/openhubble-cli
fi

echo "OpenHubble CLI has been uninstalled successfully."
