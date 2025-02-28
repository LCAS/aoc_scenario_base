#!/bin/bash

rosdep update

sudo apt-get update 

COLCON_WS=/home/ros/aoc_strawberry_scenario_ws

cd ${COLCON_WS}/src
vcs import < ./aoc_strawberry_scenario/.devcontainer/docker/ros2/repos/aoc_strawberry_scenario.repos
rosdep install --from-paths . -i -y




