#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root (use sudo)"
  exit 1
fi

set -e

# Change directory to source directory
cd /opt/openhubble-cli || {
  echo "Source directory not found."
  exit 1
}

# Pulling the latest changes from Git
echo "Pulling latest changes from Git..."
git pull origin main || {
  echo "Git pull failed."
  exit 1
}

# Updating Python dependencies
echo "Updating Python dependencies..."
/opt/openhubble-cli/.venv/bin/python3 -m pip install --no-cache-dir -r requirements.txt || {
  echo "Failed to update Python dependencies."
  exit 1
}

# Clearing Python cache
echo "Clearing Python cache..."
find /opt/openhubble-cli -name "*.pyc" -delete
find /opt/openhubble-cli -name "__pycache__" -delete

# Reload Daemon
echo "Reloading services..."
systemctl daemon-reload

echo "OpenHubble CLI has been updated successfully."
