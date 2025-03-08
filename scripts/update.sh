#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root (use sudo)"
  exit 1
fi

set -e

INSTALL_DIR="/opt/openhubble-cli"
LATEST_VERSION=$(curl -s "https://api.github.com/repos/OpenHubble/cli/releases/latest" | jq -r '.tag_name')
TARBALL_URL="https://api.github.com/repos/OpenHubble/cli/tarball/$LATEST_VERSION"

if [ -z "$LATEST_VERSION" ] || [ "$LATEST_VERSION" == "null" ]; then
  echo "Failed to get latest version."
  exit 1
fi

echo "Latest version: $LATEST_VERSION"

# Download the new version
echo "Downloading OpenHubble CLI ($LATEST_VERSION)..."
curl -L "$TARBALL_URL" -o /tmp/openhubble-cli.tar.gz

# Extract over existing installation
echo "Updating files..."
tar -xzf /tmp/openhubble-cli.tar.gz --strip-components=1 -C "$INSTALL_DIR"

# Update Python dependencies
echo "Updating dependencies..."
"$INSTALL_DIR/.venv/bin/python3" -m pip install --no-cache-dir -r "$INSTALL_DIR/requirements.txt"

# Clear Python cache
echo "Clearing Python cache..."
find "$INSTALL_DIR" -name "*.pyc" -delete
find "$INSTALL_DIR" -name "__pycache__" -delete

# Reload services
echo "Reloading services..."
systemctl daemon-reload

echo "OpenHubble CLI updated to $LATEST_VERSION."
