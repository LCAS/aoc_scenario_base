# This set up the open-vscode-server in the home directory. 
# The version is fixed to v1.94.2.
RUN wget -O ~/code-server.tar.gz https://github.com/gitpod-io/openvscode-server/releases/download/openvscode-server-v1.94.2/openvscode-server-v1.94.2-linux-x64.tar.gz && \
    mkdir ~/code-server/ && \
    tar -xzf ~/code-server.tar.gz -C ~/code-server --strip-components=1 && \
    rm ~/code-server.tar.gz