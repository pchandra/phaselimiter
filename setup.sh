#!/bin/bash

DEBIAN_FRONTEND=noninteractive

# Get everything up to date
sudo apt-get update
sudo apt-get dist-upgrade -y

# Get the basic build tools
sudo apt-get install -y build-essential cmake

# Get the code
#git clone https://github.com/License-Lounge/phaselimiter
#cd phaselimiter
#git submodule init
#git submodule update

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

# Build it
cmake -DCMAKE_CXX_FLAGS=-DTBB_ALLOCATOR_TRAITS_BROKEN .
make

# Get runtime deps
sudo apt-get install -y ffmpeg
