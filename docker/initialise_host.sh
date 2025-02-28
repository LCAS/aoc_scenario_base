#!/bin/bash

set -e


robot_platform="${1:-hunter_platform}"

# set the main branch
main_branch="humble_dev"
base_image_base="lcas.lincoln.ac.uk/lcas/aoc_strawberry_scenario"

# Color definitions
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
RESET='\033[0m'  # Reset to default color
BOLD='\033[1m'

# function to determine if a specific image tag exists on the registry:
# $1: the image to check
function image_tag_exists() {
    # check if the image tag exists
    if docker manifest inspect $1 > /dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

# function to extract semantic version from a string
# $1: the string to extract the version from
function extract_semantic_version() {
    # extract the version from the string
    echo $1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+'
}


function get_suitable_image_tag() {
    # identify the current branch
    current_git_branch=$(git rev-parse --abbrev-ref HEAD)

    # if there is an image with the same tag as the current branch, use it
    if image_tag_exists "${base_image_base}:${robot_platform}-${current_git_branch}"; then
        echo "${base_image_base}:${robot_platform}-${current_git_branch}"
        return
    fi

    latest_release_tag=$(git describe --tags `git rev-list --tags --max-count=1`)
    version_tag=$(extract_semantic_version $latest_release_tag)

    # if there is an image with the same tag as the latest release, use it
    if image_tag_exists "${base_image_base}:${robot_platform}-${version_tag}"; then
        echo "${base_image_base}:${robot_platform}-${version_tag}"
        return
    fi

    # if none of the above, return the staging image
    # if image_tag_exists "${base_image_base}:${robot_platform}-staging"; then
    #     echo "${base_image_base}:${robot_platform}-staging"
    #     return
    # fi
    echo "no image found" >&2   
    false


}


echo "$(get_suitable_image_tag)"



