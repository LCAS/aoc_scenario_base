RUN nvidia-smi
RUN sudo apt install zstd -y && \
    curl -L -o /tmp/ZED-installer.run https://download.stereolabs.com/zedsdk/4.0/cu121/ubuntu22 && \
    chmod +x /tmp/ZED-installer.run && \
    /tmp/ZED-installer.run -- silent skip_od_module skip_cuda < /dev/zero && \
    rm -f /tmp/ZED-installer.run
