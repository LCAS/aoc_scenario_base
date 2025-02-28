RUN mkdir -p /tmp/git-lfs-build && \
    cd /tmp/git-lfs-build && \
    wget https://github.com/git-lfs/git-lfs/releases/download/v3.5.1/git-lfs-linux-amd64-v3.5.1.tar.gz && \
    tar -vxf git-lfs-linux-amd64-v3.5.1.tar.gz  && \
    cd git-lfs-3.5.1 && sudo ./install.sh
ENV GIT_LFS_SKIP_SMUDGE=1
