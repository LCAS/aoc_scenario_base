#!/bin/bash

# This script is executed after the creation of the development container.
# It sets the shell options to:
# -e: Exit immediately if a command exits with a non-zero status.
# -x: Print commands and their arguments as they are executed.
set -e -x

# NO LONGER NEEDED DUE TO SUBMODULES
#bash ${AOC_SERVICE_DIR}/.devcontainer/docker/ros2/script/checkout_private_repos.sh

bash ${AOC_SERVICE_DIR}/.devcontainer/docker/ros2/script/startup.sh

bash ${AOC_SERVICE_DIR}/.devcontainer/docker/ros2/script/build_workspace.sh || true 
# Run start up script which will share internet for real robot and start mongod instance 
