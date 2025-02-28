RUN mkdir -p /tmp/zenoh-build && \ 
    cd /tmp/zenoh-build && \
    (curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y) && \
    git clone https://github.com/eclipse-zenoh/zenoh-plugin-ros2dds.git && \
    cd /tmp/zenoh-build/zenoh-plugin-ros2dds && \
    /bin/bash -c "source '$HOME/.cargo/env'; cargo build --release -p zenoh-bridge-ros2dds" && \
    install target/release/zenoh-bridge-ros2dds /usr/local/bin/
