RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc && \
    echo "source /usr/share/colcon_cd/function/colcon_cd.sh" >> ~/.bashrc && \
    echo "export _colcon_cd_root=${COLCON_WS}" >> ~/.bashrc && \
    echo "source ${COLCON_WS}/install/setup.bash" >> ~/.bashrc

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
    echo "alias remote_code_editor='~/code-server/bin/openvscode-server --host 0.0.0.0 --port 5001 --without-connection-token --telemetry-level off'" >> ~/.bashrc && \
    echo "alias startup='bash ${AOC_SERVICE_DIR}/.devcontainer/docker/ros2/script/startup.sh'" >> ~/.bashrc && \
    echo "export GAZEBO_RESOURCE_PATH=/usr/share/gazebo-11" >> ~/.bashrc && \
    echo "export GAZEBO_MASTER_URI=http://127.0.0.0:21345" >> ~/.bashrc && \
    echo "export GAZEBO_IP=127.0.0.0" >> ~/.bashrc && \
    echo "export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp" >> ~/.bashrc && \
    echo "export RCUTILS_COLORIZED_OUTPUT=1" >> ~/.bashrc && \
    echo "export ROS_LOCALHOST_ONLY=1" >> ~/.bashrc

