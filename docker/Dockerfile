ARG BASE_IMAGE=lcas.lincoln.ac.uk/lcas/ros-docker-images:jammy-cuda12.2-humble-2.1.0

############################################################################################################
FROM ${BASE_IMAGE} AS base
ARG BASE_IMAGE
ENV BASE_IMAGE=${BASE_IMAGE}

LABEL org.opencontainers.image.authors="Agri-OpenCore Consortium" \
      org.opencontainers.image.licenses="Apache 2.0, MIT, others" \
      org.opencontainers.image.vendor="Agri-OpenCore Consortium" \
      org.opencontainers.image.title="Agri-OpenCore Base Scenario ROS 2 Workspace" \
      org.opencontainers.image.description="This image is used to build the Agri-OpenCore Base Scenario ROS 2 workspace." \
      org.opencontainers.image.url="https://github.com/LCAS/aoc_scenario_base" \
      org.opencontainers.image.documentation="https://github.com/LCAS/aoc_scenario_base" \
      org.opencontainers.image.source="https://github.com/LCAS/aoc_scenario_base" \
      uk.ac.lincoln.lcas.maintainer="Ibrahim Hroob <ihroob@lincoln.ac.uk>" \
      uk.ac.lincoln.lcas.affiliation="University of Lincoln, Lincoln Centre for Autonomous Systems" \
      uk.ac.lincoln.lcas.description="This image is used to build the AOC Base Scenario ROS 2 workspace." \
      uk.ac.lincoln.lcas.base_image=${BASE_IMAGE}

USER root

#change this to ARG https://docs.docker.com/reference/dockerfile/#env
#If an environment variable is only needed during build, and not in the final image
ENV DEBIAN_FRONTEND=noninteractive

# Install all required APT packages
#INCLUDE docker/apt_install.dockerfile
RUN apt update && apt upgrade -y && \
    apt install -y \
    ros-${ROS_DISTRO}-desktop \
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

# Install extra libraries via script
COPY --link docker/script/install_extra_libs.sh /opt/src/scripts/install_extra_libs.sh
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
#INCLUDE docker/zed.dockerfile
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
RUN sudo chmod -R o+r+w+X,g+r+w+X /opt/venv


USER root

#### FROM HERE ON IT'S HARDWARE SPECIFIC, i.e., everything below this line will result in different images for different robots
# To maximise the cache usage, when building the image for each robot separately, we should try to put everything that is shared 
# between the different robots above this line, and everything that is specific to a robot below this line
#FROM extensions AS hardware_specific
# ARG ROBOT_PLATFORM=dogtooth_platform
# ENV ROBOT_PLATFORM=${ROBOT_PLATFORM}

# COPY --link docker/script/install_extra_libs_hardware_specific.sh /opt/src/scripts/install_extra_libs_hardware_specific.sh
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

# switch to the user now
USER $USER

# tmule configs
RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc && \
    echo "source /usr/share/colcon_cd/function/colcon_cd.sh" >> ~/.bashrc && \

# common aliases
RUN echo "export GAZEBO_RESOURCE_PATH=/usr/share/gazebo-11" >> ~/.bashrc && \
    echo "export GAZEBO_MASTER_URI=http://127.0.0.0:21345" >> ~/.bashrc && \
    echo "export GAZEBO_IP=127.0.0.0" >> ~/.bashrc && \
    echo "export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp" >> ~/.bashrc && \
    echo "export RCUTILS_COLORIZED_OUTPUT=1" >> ~/.bashrc

# default to bash
CMD ["/bin/bash"]
