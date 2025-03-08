#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root (use sudo)"
  exit 1
fi

# Install dependencies
apt update -y
apt install -y python3 python3-venv python3-pip curl tar jq

# Set install directory
INSTALL_DIR="/opt/openhubble-cli"

# Get the latest release tag from GitHub
LATEST_VERSION=$(curl -s "https://api.github.com/repos/OpenHubble/cli/releases/latest" | jq -r '.tag_name')

if [ -z "$LATEST_VERSION" ] || [ "$LATEST_VERSION" == "null" ]; then
  echo "Failed to get latest version."
  exit 1
fi

TARBALL_URL="https://api.github.com/repos/OpenHubble/cli/tarball/$LATEST_VERSION"

echo "Installing OpenHubble CLI version $LATEST_VERSION..."

# Create directory if not exists
mkdir -p "$INSTALL_DIR"

# Download and extract the latest version
curl -L "$TARBALL_URL" -o /tmp/openhubble-cli.tar.gz
tar -xzf /tmp/openhubble-cli.tar.gz --strip-components=1 -C "$INSTALL_DIR"

# Create virtual environment
echo "Creating virtual environment..."
python3 -m venv "$INSTALL_DIR/.venv"

# Install Python dependencies
echo "Installing dependencies..."
"$INSTALL_DIR/.venv/bin/python3" -m pip install --no-cache-dir -r "$INSTALL_DIR/requirements.txt"

# Make CLI executable
chmod +x "$INSTALL_DIR/cli/wrapper.sh"

# Create symbolic link
ln -sf "$INSTALL_DIR/cli/wrapper.sh" /usr/local/bin/openhubble-cli

echo "OpenHubble CLI ($LATEST_VERSION) installed successfully."
