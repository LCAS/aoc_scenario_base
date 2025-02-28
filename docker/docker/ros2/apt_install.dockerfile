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
