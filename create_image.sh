#!/bin/bash

# Configuration Variables
export REPO_URL="https://github.com/armbian/build"
export BOARD="bigtreetech-cb1"
export BRANCH="current"
export RELEASE="bookworm"
export BUILD_DESKTOP="no"
export KERNEL_CONFIGURE="no"
export BUILD_MINIMAL="yes"
export NETWORKING_STACK="network-manager"
export CONSOLE_AUTOLOGIN="no"
export INCLUDE_HOME_DIR="yes"
export WIREGUARD="no"
export CLEAN_LEVEL="caches,alldebs,sources,oldcache"

# Update and install required packages
sudo apt-get update
sudo apt-get install -y git curl build-essential qemu-user-static

# Clone the Armbian build repository
git clone --depth 1 "$REPO_URL"

# Copy the entire userpatches directory into the build directory
cp -rfv userpatches/ "build/"
chmod -R +x "build/userpatches/*.sh"

# Run the compile script
cd build
./compile.sh
