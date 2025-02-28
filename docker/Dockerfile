ARG BASE_IMAGE=lcas.lincoln.ac.uk/lcas/ros-docker-images:jammy-cuda12.2-humble-2

############################################################################################################
FROM ${BASE_IMAGE} AS base
LABEL org.opencontainers.image.authors="Agri-OpenCore Consortium" \
      org.opencontainers.image.licenses="Apache 2.0, MIT, others" \
      org.opencontainers.image.vendor="Agri-OpenCore Consortium" \
      org.opencontainers.image.title="Agri-OpenCore Strawberry Scenario ROS 2 Workspace" \
      org.opencontainers.image.description="This image is used to build the Agri-OpenCore Strawberry Scenario ROS 2 workspace." \
      org.opencontainers.image.url="https://github.com/LCAS/aoc_strawberry_scenario" \
      org.opencontainers.image.documentation="https://github.com/LCAS/aoc_strawberry_scenario" \
      org.opencontainers.image.source="https://github.com/LCAS/aoc_strawberry_scenario" \
      uk.ac.lincoln.lcas.maintainer="Ibrahim Hroob <ihroob@lincoln.ac.uk>" \
      uk.ac.lincoln.lcas.affiliation="University of Lincoln, Lincoln Centre for Autonomous Systems" \
      uk.ac.lincoln.lcas.description="This image is used to build the AOC Strawberry Scenario ROS 2 workspace." \
      uk.ac.lincoln.lcas.base_image=${BASE_IMAGE}

USER root

#change this to ARG https://docs.docker.com/reference/dockerfile/#env
#If an environment variable is only needed during build, and not in the final image
ARG DEBIAN_FRONTEND=noninteractive
ENV ROS_DISTRO=humble

ARG COLCON_WS=/home/ros/aoc_strawberry_scenario_ws
ENV COLCON_WS=${COLCON_WS}

# Install all required APT packages
#INCLUDE .devcontainer/docker/ros2/apt_install.dockerfile
RUN apt update && apt upgrade -y && \
    apt install -y \
    ros-humble-desktop \
    ros-${ROS_DISTRO}-gazebo-* \
    ros-${ROS_DISTRO}-navigation2 \
    ros-${ROS_DISTRO}-gazebo-ros-pkgs \
    ros-${ROS_DISTRO}-interactive* \
    ros-${ROS_DISTRO}-twist* \
    ros-${ROS_DISTRO}-nav2-* \
    ros-${ROS_DISTRO}-octomap* \
    ros-${ROS_DISTRO}-grid-map \
    ros-${ROS_DISTRO}-imu-tools \
    ros-${ROS_DISTRO}-robot-localization \
    ros-${ROS_DISTRO}-tf2* \
    ros-${ROS_DISTRO}-rclpy-message-converter \
    ros-${ROS_DISTRO}-rmw-cyclonedds-cpp \
    ros-${ROS_DISTRO}-cyclonedds \
    ros-${ROS_DISTRO}-zenoh-bridge-dds \
    ros-${ROS_DISTRO}-image-transport \
    ros-${ROS_DISTRO}-compressed-image-transport \
    ros-dev-tools \
    llvm-dev \
    libclang-dev \
    libompl-dev \
    python-is-python3 \
    python3-pip \
    nano \
    tmux \
    sudo \
    less \
    locate \
    v4l-utils \
    ffmpeg \
    libasio-dev \
    libeigen3-dev \
    libgflags-dev \
    libopenvdb-dev \
    libgoogle-glog-dev \
    xterm \
    openvpn \
    iptables \
    net-tools \
    iproute2 \
    can-utils \
    usbutils \
    iputils-ping && \
    rm -rf /var/lib/apt/lists/*

# This Dockerfile sets up a ROS 2 development environment. It starts by setting the environment variable USER to 'ros'.

WORKDIR /home/ros

# ENVs
ENV HOME=/home/ros
ENV PATH="/home/ros/.local/bin:${PATH}"
# Force Python stdout and stderr streams to be unbuffered.
ENV PYTHONUNBUFFERED=1
# Set the LD_PRELOAD environment variable
ENV LD_PRELOAD=/usr/lib/libdlfaker.so:/usr/lib/libvglfaker.so
# enable all capabilities for the container
ENV NVIDIA_DRIVER_CAPABILITIES=all

# install all the required extensions

# Install mqtt packages 
RUN pip3 install --no-cache-dir paho-mqtt msgpack pyudev tmule==1.5.9 notebook


# Remote Code Server 
#############################################################################################
## This sets up the remote code server that is served using zrok share. 
# This set up the open-vscode-server in the home directory. 
# The version is fixed to v1.94.2.
RUN wget -O ~/code-server.tar.gz https://github.com/gitpod-io/openvscode-server/releases/download/openvscode-server-v1.94.2/openvscode-server-v1.94.2-linux-x64.tar.gz && \
    mkdir ~/code-server/ && \
    tar -xzf ~/code-server.tar.gz -C ~/code-server --strip-components=1 && \
    rm ~/code-server.tar.gz

# MongoDB
############################################################################################################
##================== install mongodb v7.0
# instructions: https://www.mongodb.com/docs/manual/tutorial/install-mongodb-on-ubuntu/

# 1) Import the public key used by the package management system
RUN curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
    gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
    --dearmor

# 2) Create a list file for MongoDB
RUN echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

# 3) Reload local package database
RUN apt-get update 

# 4) Install the MongoDB packages
RUN apt-get install -y mongodb-org

# 5) Pin the package at the currently installed version
RUN echo "mongodb-org hold" | sudo dpkg --set-selections            \
    echo "mongodb-org-database hold" | sudo dpkg --set-selections   \
    echo "mongodb-org-server hold" | sudo dpkg --set-selections     \
    echo "mongodb-mongosh hold" | sudo dpkg --set-selections        \
    echo "mongodb-org-mongos hold" | sudo dpkg --set-selections     \
    echo "mongodb-org-tools hold" | sudo dpkg --set-selections

##================== install mongodb Compass
# Optionally install mongodb Compass for data visualization
# Update the package list and install wget
RUN apt-get update && apt-get install -y wget

# Download the .deb file to /tmp, install it, and then remove it
RUN wget -O /tmp/mongodb-compass.deb https://downloads.mongodb.com/compass/mongodb-compass_1.43.0_amd64.deb && \
    dpkg -i /tmp/mongodb-compass.deb || apt-get install -f -y && \
    rm /tmp/mongodb-compass.deb

# Clean up apt cache to reduce image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

##================== Install pymongo
# Install pymongo
RUN python3 -m pip install pymongo


# TOPONAV editor tool
RUN pip install --upgrade matplotlib pybind11
COPY --link .devcontainer/docker/ros2/script/toponav_editor.desktop /home/ros/Desktop/
RUN chmod +x /home/ros/Desktop/toponav_editor.desktop


# DDS configurations are copied to the /etc/sysctl.d directory, and udev rules are copied to the /etc/udev/rules.d directory.
COPY --link .devcontainer/docker/ros2/config/dds_configs/10-cyclone-max.conf /etc/sysctl.d/10-cyclone-max.conf
COPY --link .devcontainer/docker/ros2/config/udev_configs/49-hardware_info_set.rules /etc/udev/rules.d/49-hardware_info_set.rules

# Install extra libraries via script
COPY --link .devcontainer/docker/ros2/script/install_extra_libs.sh /opt/src/scripts/install_extra_libs.sh
RUN chmod +x /opt/src/scripts/install_extra_libs.sh && \
    /bin/bash -c '/opt/src/scripts/install_extra_libs.sh'

# installs Git LFS using the provided install script.
RUN mkdir -p /tmp/git-lfs-build && \
    cd /tmp/git-lfs-build && \
    wget https://github.com/git-lfs/git-lfs/releases/download/v3.5.1/git-lfs-linux-amd64-v3.5.1.tar.gz && \
    tar -vxf git-lfs-linux-amd64-v3.5.1.tar.gz  && \
    cd git-lfs-3.5.1 && sudo ./install.sh
ENV GIT_LFS_SKIP_SMUDGE=1

# install zed sdk (as the user, because the installer needs to be run as a user)

# allow writing into /opt/venv by all users
RUN sudo chmod -R o+r+w+X,g+r+w+X /opt/venv
ENV USER=ros
USER $USER
#INCLUDE .devcontainer/docker/ros2/zed.dockerfile
RUN nvidia-smi || echo "::warning title=ZED installation::No nvidia-smi found, build environment not with CUDA runtime. ZED SDK will be installed with stubs" 

ENV OLD_LD_LIBRARY_PATH=$LD_LIBRARY_PATH
# add cuda stubs to the LD_LIBRARY_PATH temporarily
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64/stubs/:$LD_LIBRARY_PATH
RUN sudo apt install zstd -y && \
    curl -L -o /tmp/ZED-installer.run https://download.stereolabs.com/zedsdk/4.0/cu121/ubuntu22 && \
    chmod +x /tmp/ZED-installer.run && \
    /tmp/ZED-installer.run -- silent skip_od_module skip_cuda < /dev/zero && \
    rm -f /tmp/ZED-installer.run

# install the python bindings for the ZED SDK separately, as the installer seems to struggle with our setup    
RUN pip install https://download.stereolabs.com/zedsdk/4.0/whl/linux_x86_64/pyzed-4.0-cp310-cp310-linux_x86_64.whl

ENV LD_LIBRARY_PATH=$OLD_LD_LIBRARY_PATH

# fix permission for zed installation
RUN sudo chmod -R +r+X /usr/local/

USER root

#### FROM HERE ON IT'S HARDWARE SPECIFIC, i.e., everything below this line will result in different images for different robots
# To maximise the cache usage, when building the image for each robot separately, we should try to put everything that is shared 
# between the different robots above this line, and everything that is specific to a robot below this line
#FROM extensions AS hardware_specific
# ARG ROBOT_PLATFORM=dogtooth_platform
# ENV ROBOT_PLATFORM=${ROBOT_PLATFORM}

# COPY --link .devcontainer/docker/ros2/script/install_extra_libs_hardware_specific.sh /opt/src/scripts/install_extra_libs_hardware_specific.sh
# RUN chmod +x /opt/src/scripts/install_extra_libs_hardware_specific.sh && \
#     /bin/bash -c '/opt/src/scripts/install_extra_libs_hardware_specific.sh ${ROBOT_PLATFORM}'

# Add the current user to the dialout, video, and tty groups.
# This grants the user permissions to access serial ports, video devices, and terminal devices respectively.
RUN usermod -a -G dialout $USER && \
    usermod -a -G video $USER && \
    usermod -a -G tty $USER && \
    mkdir -p ${COLCON_WS}/src/

RUN mkdir -p ${COLCON_WS}
RUN chown -R $USER:$USER ${COLCON_WS}


############################################################################################################
FROM base AS user_space
ARG AOC_SERVICE_DIR=${COLCON_WS}/src/aoc_strawberry_scenario
ENV AOC_SERVICE_DIR=${AOC_SERVICE_DIR}
ARG ROBOT_PLATFORM=dogtooth_platform
ENV ROBOT_PLATFORM=${ROBOT_PLATFORM}

# switch to the user now
USER $USER

# tmule configs
ARG ROBOT_PLATFORM_TMULE=${AOC_SERVICE_DIR}/aoc_strawberry_scenario_bringup/tmule/tmule_config/robots/${ROBOT_PLATFORM}
ENV ROBOT_PLATFORM_TMULE=${ROBOT_PLATFORM_TMULE}

RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc && \
    echo "source /usr/share/colcon_cd/function/colcon_cd.sh" >> ~/.bashrc && \
    echo "export _colcon_cd_root=${COLCON_WS}" >> ~/.bashrc && \
    echo "source ${COLCON_WS}/install/setup.bash" >> ~/.bashrc

RUN echo "source ${ROBOT_PLATFORM_TMULE}/init_cmd_setup_${ROBOT_PLATFORM}.sh" >> ~/.bashrc && \
    echo "alias aoc_strawberry_scenario_tmule_cd='cd ${ROBOT_PLATFORM_TMULE}/'" >> ~/.bashrc && \
    echo "alias aoc_strawberry_scenario_tmule_exec='tmule -c ${ROBOT_PLATFORM_TMULE}/aoc_strawberry_scenario_${ROBOT_PLATFORM}.yaml launch'" >> ~/.bashrc

# common aliases
RUN echo "alias simulated_robot='ros2 launch aoc_strawberry_scenario_bringup robot_with_world_sim.launch.py'" >> ~/.bashrc && \
    echo "alias zenoh='zenoh-bridge-ros2dds -c /home/ros/aoc_strawberry_scenario_ws/src/aoc_strawberry_scenario/.devcontainer/docker/ros2/config/dds_configs/zenoh_client_config.json5'" >>  ~/.bashrc && \
    echo "alias navigation='ros2 launch aoc_strawberry_scenario_bringup navigation_ekf_gps.launch.py'" >> ~/.bashrc && \
    echo "alias topo_nav='ros2 launch aoc_strawberry_scenario_bringup topological_nav.launch.py'" >> ~/.bashrc && \
    echo "alias topo_nav_real='ros2 launch aoc_strawberry_scenario_bringup topological_nav.launch.py use_sim_time:=False'" >> ~/.bashrc && \
    echo "alias navigation_without_rviz='ros2 launch aoc_strawberry_scenario_bringup navigation_ekf_gps.launch.py use_rviz:=False'" >> ~/.bashrc && \
    echo "alias scenario_viz='ros2 launch aoc_strawberry_scenario_bringup rviz_launch.py'" >> ~/.bashrc && \
    echo "alias scenario_viz_real='ros2 launch aoc_strawberry_scenario_bringup rviz_launch.py use_sim_time:=False'" >> ~/.bashrc && \
    echo "alias navigation_real_robot='ros2 launch aoc_strawberry_scenario_bringup navigation_ekf_gps.launch.py use_sim_time:=False use_rviz:=False'" >> ~/.bashrc && \
    echo "alias set_usb_permission='sudo chmod -R 777 /dev/bus/usb/'" >> ~/.bashrc && \
    echo "alias share_internet='bash ${AOC_SERVICE_DIR}/.devcontainer/docker/ros2/config/network_config/sharing_internet.sh'" >> ~/.bashrc && \
    echo "alias real_robot='ros2 launch aoc_strawberry_scenario_bringup robot_with_world_real.launch.py'" >> ~/.bashrc && \
    echo "alias post_create='bash ${AOC_SERVICE_DIR}/.devcontainer/docker/ros2/script/post_create.sh'" >> ~/.bashrc && \
    echo "alias startup='bash ${AOC_SERVICE_DIR}/.devcontainer/docker/ros2/script/startup.sh'" >> ~/.bashrc && \
    echo "export GAZEBO_RESOURCE_PATH=/usr/share/gazebo-11" >> ~/.bashrc && \
    echo "export GAZEBO_MASTER_URI=http://127.0.0.0:21345" >> ~/.bashrc && \
    echo "export GAZEBO_IP=127.0.0.0" >> ~/.bashrc && \
    echo "export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp" >> ~/.bashrc && \
    echo "export RCUTILS_COLORIZED_OUTPUT=1" >> ~/.bashrc


# Create the workspace directory and copy the repos into it
RUN mkdir -p ${COLCON_WS}/src/
WORKDIR ${COLCON_WS}/src/

# make sure again that it's writeable
RUN sudo chmod -R o+r+w+X,g+r+w+X /opt/venv

# default to bash
CMD ["/bin/bash"]

FROM user_space AS deps_installed

RUN --mount=type=bind,target=/tmp/source-tree \
    rosdep update --rosdistro ${ROS_DISTRO} && \
    rosdep install --from-paths /tmp/source-tree --ignore-src --rosdistro ${ROS_DISTRO} -y



