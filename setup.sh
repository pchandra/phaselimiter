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
cmake -DCMAKE_CXX_FLAGS=-DTBB_ALLOCATOR_TRAITS_BROKEN .
make

# Get runtime deps
sudo apt-get install -y ffmpeg

exit

#############################
#
#  RUN: on Ubuntu 22.04 with a phase_limiter binary, 
#  there are a number of additional runtime dependencies
#
#############################

sudo apt-get install -y libsndfile1-dev

sudo apt-get install -y ffmpeg

wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB \
 | gpg --dearmor | sudo tee /usr/share/keyrings/oneapi-archive-keyring.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" \
 | sudo tee /etc/apt/sources.list.d/oneAPI.list

sudo apt-get update
sudo apt-get install -y intel-basekit

. /opt/intel/oneapi/setvars.sh

#############################
#
#  WORKER: on Ubuntu 22.04 several other tools need to be
#  installed in order to run a full worker node
#
#############################

sudo apt-get install -y python3 python3-pip

# Third-party tools that we run
python3 -m pip install demucs

python3 -m pip install openai-whisper

python3 -m pip install basic-pitch

# Get the home-made tools too
pushd .
cd ~/
git clone https://github.com/License-Lounge/wav-mixer
git clone https://github.com/License-Lounge/key-bpm-finder
popd

# Dependencies for the home-made tools we just cloned
python3 -m pip install librosa matplotlib numpy numba

# Dependencies for running the actual lab-director components
python3 -m pip install Flask Flask-shelve zmq
