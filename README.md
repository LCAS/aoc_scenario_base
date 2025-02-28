# AOC Scenario Base Docker Environment

This repository provides a Docker base image for scenarios in the Agri-OpenCore (AOC) project. The base image installs all non-ROS2 open source dependencies required to build AOC software.

It's based on the L-CAS ROS Cuda Desktop Images: https://github.com/LCAS/ros-docker-images

## Key Components

### Base Image
- Built on top of `lcas.lincoln.ac.uk/lcas/ros-docker-images` (currently `jammy-cuda12.2-humble-2.1.0` tag) 
- Uses Ubuntu 22.04 (Jammy) with CUDA support
- ROS2 Humble distribution

### Main Features
- ROS2 Humble desktop installation
- Navigation2 and Gazebo simulation packages
- MongoDB 7.0 with Compass GUI
- ZED SDK 4.0 with CUDA support
- Code-server (VS Code in browser) setup
- MQTT support via paho-mqtt
- Various ROS2 packages for:
    - Navigation
    - Simulation
    - Image processing
    - Robot localization
    - Mapping

The following packages are installed from source:

| Package | Version | Repository | Description/Features |
|---------|---------|------------|---------------------|
| g2o | Debian/Humble branch | [libg2o-release](https://github.com/ros2-gbp/libg2o-release) | General Graph Optimization framework |
| IPOPT Solver | 3.13 (stable) | [Ipopt](https://github.com/coin-or/Ipopt) | |
| control_box_rst | v0.0.0 | [control_box_rst](https://github.com/LCAS/control_box_rst) | |
| DecompROS | humble_dev branch | [DecompROS](https://github.com/LCAS/DecompROS) | |
| kindr | v0.0.0 | [kindr](https://github.com/LCAS/kindr) | |
| GTSAM | commit 6c97e4b | [gtsam](https://github.com/borglab/gtsam) | |
| OpenVDB | v10.0.1 | [openvdb](https://github.com/AcademySoftwareFoundation/openvdb) | |
| OctoMap | v1.9.6 | [octomap](https://github.com/OctoMap/octomap) | |
| Casadi | main branch | [casadi](https://github.com/casadi/casadi) | Built with Python, IPOPT, OpenMP, and Thread support |
| Livox SDK2 | v0.0.0 | [Livox-SDK2](https://github.com/LCAS/Livox-SDK2) | |

### CI/CD Pipeline
- Automated Docker image builds via GitHub Actions
- Builds triggered on:
    - Push to main branch
    - Pull requests
    - Version tags
    - Manual dispatch
- Images pushed to LCAS private registry

### Build
The image can be build locally via Docker Compose or bake:

```
docker compose build
```

or 

```
docker buildx bake 
```
