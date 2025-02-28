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