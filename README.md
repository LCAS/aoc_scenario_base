# aoc_scenario_base

# AOC Scenario Base Docker Environment

This repository provides a Docker base image for scenarios in the Agri-OpenCore (AOC) project. The base image installs all non-ROS2 open source dependencies required to build AOC software.

## Key Components

### Base Image
- Built on top of `lcas.lincoln.ac.uk/lcas/ros-docker-images:jammy-cuda12.2-humble-2`
- Uses Ubuntu 22.04 (Jammy) with CUDA 12.2 support
- ROS2 Humble distribution

### Main Features
- ROS2 Humble desktop installation
- Navigation2 and Gazebo simulation packages
- MongoDB 7.0 with Compass GUI
- ZED SDK 4.0 with CUDA 12.1 support
- Code-server (VS Code in browser) setup
- MQTT support via paho-mqtt
- Various ROS2 packages for:
    - Navigation
    - Simulation
    - Image processing
    - Robot localization
    - Mapping

### CI/CD Pipeline
- Automated Docker image builds via GitHub Actions
- Builds triggered on:
    - Push to main branch
    - Pull requests
    - Version tags
    - Manual dispatch
- Images pushed to LCAS private registry

### Usage
The image can be build locally via Docker Compose:

```
docker compose build
```
