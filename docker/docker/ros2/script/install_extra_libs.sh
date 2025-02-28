#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e -x

# Global constants
TMP_DIR="/tmp"
CURRENT_DIR="$(pwd)"

# Utility function to check if a library is installed
is_installed() {
    ls /usr/local/include | grep -q "$1"
}

# Utility function to create and navigate to a temporary directory
create_temp_dir() {
    mktemp -d
}

# Function to install g2o
install_g2o() {
    echo "Prepare to install g2o"
    TEMP_DIR=$(create_temp_dir)
    
    if is_installed "g2o"; then
        echo "g2o is already installed."
    else
        cd "$TEMP_DIR"
        git clone --branch debian/humble/libg2o --depth 1 https://github.com/ros2-gbp/libg2o-release.git
        cd libg2o-release
        mkdir build && cd build
        cmake ../
        make -j"$(nproc)"
        sudo make install
        echo "g2o installed successfully."
    fi

    # Clean up
    cd "$TMP_DIR"
    rm -rf "$TEMP_DIR"
    sudo ldconfig
}

# Function to install OctoMap
install_octomap() {
    echo "Prepare to install OctoMap"
    TEMP_DIR=$(create_temp_dir)
    
    if is_installed "dynamicEDT3D"; then
        echo "OctoMap is already installed."
    else
        sudo apt-get install -y wget
        cd "$TEMP_DIR"
        wget https://github.com/OctoMap/octomap/archive/refs/tags/v1.9.6.tar.gz
        tar -xvf v1.9.6.tar.gz
        cd octomap-1.9.6/
        mkdir build && cd build
        cmake ..
        make -j"$(nproc)"
        sudo make install
        echo "OctoMap installed successfully."
    fi

    # Clean up
    cd "$TMP_DIR"
    rm -rf "$TEMP_DIR"
}

# Function to install control_box_rst
install_control_box_rst() {
    echo "Prepare to install control_box_rst"
    TEMP_DIR=$(create_temp_dir)
    
    if is_installed "control_box_rst"; then
        echo "control_box_rst is already installed."
    else
        sudo apt-get install -y wget
        cd "$TEMP_DIR"
        git clone --branch v0.0.0 --depth 1  https://github.com/LCAS/control_box_rst.git
        cd control_box_rst/
        mkdir build && cd build
        cmake -DIPOPT_DIR=/usr/local ..
        make -j"$(nproc)"
        sudo make install
        echo "control_box_rst installed successfully."
    fi

    # Clean up
    cd "$TMP_DIR"
    rm -rf "$TEMP_DIR"
}

# Function to install OpenVDB
install_openvdb() {
    echo "Prepare to install OpenVDB"
    TEMP_DIR=$(create_temp_dir)
    
    if is_installed "openvdb"; then
        echo "OpenVDB is already installed."
    else
        cd "$TEMP_DIR"
        git clone --branch v10.0.1 --depth 1  https://github.com/AcademySoftwareFoundation/openvdb.git
        cd openvdb
        mkdir build && cd build
        cmake -DCMAKE_BUILD_TYPE=Release -DOPENVDB_BUILD_PYTHON_MODULE=OFF -DOPENVDB_CORE_SHARED=ON -DOPENVDB_CORE_STATIC=OFF -DOPENVDB_BUILD_BINARIES=OFF -DOPENVDB_CXX_STRICT=OFF -DUSE_CCACHE=ON ..
        val=$(( "$(nproc)" / 2 )) # Use half of the available cores for building
        make -j"$val"
        sudo make install
        sudo ldconfig
        echo "OpenVDB installed successfully."
    fi

    # Clean up
    cd "$TMP_DIR"
    rm -rf "$TEMP_DIR"
}

# Function to install IPOPT solver
install_ipopt_solver() {
    TEMP_DIR=$(create_temp_dir)
    
    if is_installed "coin"; then
        echo "IPOPT solver is already installed."
    else
        sudo apt-get install -y gcc g++ gfortran git patch wget pkg-config liblapack-dev libmetis-dev
        cd "$TEMP_DIR"
        
        # Install ThirdParty-ASL
        git clone --branch releases/2.0.1 --depth 1 https://github.com/coin-or-tools/ThirdParty-ASL.git
        cd ThirdParty-ASL
        ./get.ASL
        ./configure
        make
        sudo make install
        
        # Install ThirdParty-Mumps
        cd "$TEMP_DIR"
        git clone --branch releases/3.0.7 --depth 1 https://github.com/coin-or-tools/ThirdParty-Mumps.git
        cd ThirdParty-Mumps
        ./get.Mumps
        ./configure
        make -j"$(nproc)"
        sudo make install
        
        # Install Ipopt
        cd "$TEMP_DIR"
        git clone --depth 1  --single-branch --branch stable/3.13 https://github.com/coin-or/Ipopt.git
        cd Ipopt
        mkdir -p build && cd build
        ../configure --prefix=/usr/local ADD_FFLAGS=-fPIC ADD_CFLAGS=-fPIC ADD_CXXFLAGS=-fPIC
        make -j"$(nproc)"
        sudo make install
        sudo ldconfig

        # Update environment variables
        echo "export IPOPT_DIR=/usr/local" >> ~/.bashrc
        cd /usr/local/include
        sudo cp -r coin-or coin
        echo "IPOPT solver installed successfully."
    fi

    # Clean up
    cd "$TMP_DIR"
    rm -rf "$TEMP_DIR"
}

# Function to install kindr
install_kindr() {
    echo "Prepare to install kindr"
    TEMP_DIR=$(create_temp_dir)
    
    if is_installed "kindr"; then
        echo "kindr is already installed."
    else
        cd "$TEMP_DIR"
        git clone --branch v0.0.0 --depth 1 https://github.com/LCAS/kindr.git
        cd kindr
        mkdir build && cd build
        cmake ..
        make -j"$(nproc)"
        sudo make install
        echo "kindr installed successfully."
    fi

    # Clean up
    cd "$TMP_DIR"
    rm -rf "$TEMP_DIR"
}

# Function to install DecompROS
install_decomp_ros() {
    echo "Prepare to install DecompROS"
    TEMP_DIR=$(create_temp_dir)
    
    if is_installed "DecompROS"; then
        echo "DecompROS is already installed."
    else
        cd "$TEMP_DIR"
        git clone --branch humble_dev --depth 1 https://github.com/LCAS/DecompROS.git
        cd DecompROS
        mkdir build && cd build
        cmake ..
        make -j"$(nproc)"
        sudo make install
        echo "DecompROS installed successfully."
    fi

    # Clean up
    cd "$TMP_DIR"
    rm -rf "$TEMP_DIR"
}

# Function to install GTSAM
install_gtsam() {
    echo "Prepare to install Gtsam"
    TEMP_DIR=$(create_temp_dir)
    
    if is_installed "gtsam"; then
        echo "Gtsam is already installed."
    else
        cd "$TEMP_DIR"
        git clone https://github.com/borglab/gtsam.git
        cd gtsam
        git checkout 6c97e4b
        mkdir build && cd build
        cmake -DGTSAM_BUILD_EXAMPLES_ALWAYS=OFF ..
        make -j"$(nproc)"
        sudo make install
        echo "Gtsam installed successfully."
    fi

    # Clean up
    cd "$TMP_DIR"
    rm -rf "$TEMP_DIR"
}


# Function to install Casadi
install_casadi() {
    echo "Prepare to install Casadi"
    TEMP_DIR=$(create_temp_dir)
    
    if is_installed "casadi"; then
        echo "Casadi is already installed."
    else
        cd "$TEMP_DIR"
        sudo apt install -y  swig --install-recommends
        git clone https://github.com/casadi/casadi.git -b main casadi
        cd casadi
        mkdir build && cd build
        cmake -DWITH_PYTHON=ON -DWITH_IPOPT=ON -DWITH_OPENMP=ON -DWITH_THREAD=ON ..
        make -j"$(nproc)"
        sudo make install
        pkg-config --libs casadi
        echo "Casadi installed successfully."
    fi

    # Clean up
    cd "$TMP_DIR"
    rm -rf "$TEMP_DIR"
}

install_livox_sdk2() {
    if ls /usr/local/include | grep -q livox_lidar; then
        echo "livox_sdk2 is already installed."
    else
        echo "Installing livox_sdk2..."
        git clone --branch v0.0.0 --depth 1 https://github.com/LCAS/Livox-SDK2.git "$REPO_DIR/Livox-SDK2"
        cd "$REPO_DIR/Livox-SDK2"
        mkdir -p build
        cd build
        rm -rf *
        cmake ..
        make -j$(nproc)
        sudo make install
        echo "livox_sdk2 installed successfully."
        cd "$REPO_DIR"
        rm -rf "$REPO_DIR/Livox-SDK2"
    fi
}

# Main function to coordinate installations
main() {
    sudo apt update -y 
    install_g2o
    install_ipopt_solver
    install_control_box_rst
    install_decomp_ros
    install_kindr
    install_gtsam
    install_openvdb
    install_octomap
    install_casadi
    install_livox_sdk2
}

# Run the main function
main
