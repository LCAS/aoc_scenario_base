#!/bin/bash

# It sets the shell options to:
# -e: Exit immediately if a command exits with a non-zero status.
# -x: Print commands and their arguments as they are executed.
set -e -x

# Update and install required packages
echo "Updating and installing dependencies..."
sudo sudo apt install zstd -y

# Download and install ZED SDK
echo "Downloading and installing ZED SDK..."
curl -L -o /tmp/ZED-installer.run https://download.stereolabs.com/zedsdk/4.0/cu121/ubuntu22 && \
sudo chmod +x /tmp/ZED-installer.run

# Use valid flags for the ZED installer
echo "Running ZED installer..."
/tmp/ZED-installer.run -- silent skip_od_module skip_cuda

# Clean up
rm -f /tmp/ZED-installer.run
echo "ZED installation completed successfully."
