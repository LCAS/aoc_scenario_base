#!/bin/bash

# This script is executed after the creation of the development container.
# It sets the shell options to:
# -e: Exit immediately if a command exits with a non-zero status.
# -x: Print commands and their arguments as they are executed.
set -e -x


# Color definitions
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
RESET='\033[0m'  # Reset to default color
BOLD='\033[1m'

# Print the value of ROBOT_PLATFORM
echo -e "${BLUE}ROBOT_PLATFORM: ${YELLOW}${ROBOT_PLATFORM}${RESET}"

INSTALL_SCRIPT_DIR=${COLCON_WS}/src/aoc_strawberry_scenario/.devcontainer/docker/ros2/script

# Install repositories for the default scenario
echo -e "${GREEN}Installing aoc_strawberry_scenario repositories...${RESET}"
bash ${INSTALL_SCRIPT_DIR}/install_aoc_strawberry_scenario_repos_bash.sh aoc_strawberry_scenario.repos

# Conditionally install additional repositories based on ROBOT_PLATFORM
if [ "$ROBOT_PLATFORM" == "dogtooth_platform" ]; then
    echo -e "${GREEN}Installing dogtooth_platform repositories...${RESET}"
    bash ${INSTALL_SCRIPT_DIR}/install_aoc_strawberry_scenario_repos_bash.sh dogtooth_platform.repos
fi

# Additional setup commands
echo -e "${GREEN}Checkout complete!${RESET}"
