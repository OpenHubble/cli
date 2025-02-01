#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root (use sudo)"
  exit 1
fi

# Update packages
apt update -y

# Install some requirements
apt install -y git python3 python3-venv python3-pip

# Create directories
echo "Creating directories..."
mkdir -p /opt/openhubble-cli # App source

# Change directory to source directory
cd /opt/openhubble-cli

# Clone the project using git
echo "Cloning the project..."
git clone https://github.com/OpenHubble/cli . || {
  echo "Git clone failed."
  exit 1
}

# Create a hidden virtual environment
echo "Creating virtual environment..."
python3 -m venv .venv || {
  echo "Failed to create virtual environment."
  exit 1
}

# Install app modules
echo "Installing modules..."
/opt/openhubble-cli/.venv/bin/python3 -m pip install --no-cache-dir -r requirements.txt || {
  echo "Failed to install Python modules."
  exit 1
}

# Make cli.py executable
echo "Making cli.py executable..."
chmod +x /opt/openhubble-cli/cli/wrapper.sh

# Create a symbolic link to make openhubble-cli command available
echo "Creating symbolic link for openhubble-cli command..."
ln -sf /opt/openhubble-cli/cli/wrapper.sh /usr/local/bin/openhubble-cli

echo "OpenHubble CLI has been installed successfully."
