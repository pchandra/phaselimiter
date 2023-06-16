#!/bin/bash

#############################
#
#  BUILD: on Ubuntu 22.04 from inside a clone of
#  https://github.com/License-Lounge/phaselimiter
#
#############################


DEBIAN_FRONTEND=noninteractive

# Get everything up to date
sudo apt-get update
sudo apt-get dist-upgrade -y

# Get the basic build tools
sudo apt-get install -y build-essential cmake

# Get the build deps
sudo apt-get install -y libboost-math-dev libsndfile1-dev libgflags-dev \
  libboost-system-dev libboost-filesystem-dev libboost-serialization-dev \
  libboost-iostreams-dev libbenchmark-dev libarmadillo-dev libpng-dev

# Intel IPP libs
wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB \
 | gpg --dearmor | sudo tee /usr/share/keyrings/oneapi-archive-keyring.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" \
 | sudo tee /etc/apt/sources.list.d/oneAPI.list

sudo apt-get update
sudo apt-get install -y intel-basekit

# Get the dependencies
git submodule init
git submodule update

# The TBB_ALLOCATOR_TRAITS_BROKEN flag is needed since 
# the code relies on some of those helper methods
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-DTBB_ALLOCATOR_TRAITS_BROKEN .
make

# Get runtime deps
sudo apt-get install -y ffmpeg
