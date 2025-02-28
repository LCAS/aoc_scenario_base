#!/bin/bash

# Author and maintainer: "Ibrahim Hroob <ihroob@lincoln.ac.uk>" 

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

# Directories
COLCON_WS_SRC="/home/ros/aoc_strawberry_scenario_ws/src"
REPOS_DIR="${COLCON_WS_SRC}/repos"

# Print usage information
print_usage() {
    echo "Usage: $0 repos_file_name"
    echo "Example: $0 aoc_strawberry_scenario.repos"
}

# Check if the .repos file exists
check_repos_file() {
    local file="$1"
    if [ ! -f "$file" ]; then
        echo -e "${RED}REPOS file '$file' not found!${RESET}"
        exit 1
    fi
}

install_platform() {
    if [[ "$ROBOT_PLATFORM" == "dogtooth_platform" ]]
    then
        cd ${COLCON_WS_SRC}
        vcs import < ${REPOS_DIR}/dogtooth_platform.repos
    elif [[ "$ROBOT_PLATFORM" == "hunter_platform" ]]
    then
        echo "nothing to be done for hunter_platform"
    else
        echo "Provided robot platform related repo file not exit $2" 
        exit 1 
    fi

}

# Clone a repository from the repos file
clone_repository() {
    local repo_name="$1"
    local repo_url="$2"
    local repo_version="$3"
    local target_dir="$4"

    # Remove repo if it exists
    if [ -d "$target_dir/$repo_name" ]; then
        sudo rm -rf "$target_dir/$repo_name"
        echo -e "${YELLOW}Removed existing repository '$repo_name'.${RESET}"
    fi

    # Clone the repository
    echo -e "Cloning ${BOLD}${BLUE}${repo_name}${RESET} from ${GREEN}${repo_url}${RESET} at version ${YELLOW}${repo_version}${RESET}..."
    git clone --branch "$repo_version" "$repo_url" "$target_dir/$repo_name" && echo -e "${GREEN}Successfully cloned '$repo_name'.${RESET}" || echo -e "${RED}Failed to clone '$repo_name'.${RESET}"
    echo ""
}

# Main function to process the repos file
process_repos_file() {
    local repos_file="$1"
    local target_dir="$2"

    while read -r line
    do
        repo_name=$line
        if [[ "$repo_name" == "repositories:" ]]; then
            read -r repo_name
        fi

        read -r _type    # skip type for now
        read -r repo_url
        read -r repo_version

        repo_name=$(echo "$repo_name" | cut -d':' -f1)
        repo_url=$(echo "$repo_url" | awk '{print $2}')
        repo_version=$(echo "$repo_version" | awk '{print $2}')

        clone_repository "$repo_name" "$repo_url" "$repo_version" "$target_dir"

    done < "$repos_file"
}

main() {
    # Check if a repos file name is provided as an argument
    if [ "$#" -ne 1 ]; then
        print_usage
        exit 1
    fi

    # Construct the full path to the .repos file
    local repos_file="${REPOS_DIR}/$1"

    # Check if the REPOS file exists
    check_repos_file "$repos_file"

    rosdep update
    sudo apt update 

    # Process the REPOS file
    process_repos_file "$repos_file" "$COLCON_WS_SRC"
    #install_platform

    cd ${COLCON_WS_SRC}
    rosdep install --from-paths . -i -y

}

main "$@"
