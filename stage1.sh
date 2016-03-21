#! /bin/bash

set -e
# Any subsequent(*) commands which fail will cause the shell script to exit immediately

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Run this script as root."
    exit
fi

# For docker build.
export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get -y dist-upgrade
apt-get install -y \
    gcc \
    g++ \
    gfortran \
    build-essential \
    git \
    wget \
    linux-image-generic \
    mosh \
    libopenblas-dev \
    python-dev \
    python-pip \
    python-nose \
    python-numpy \
    python-scipy \
    python3-dev \
    python3-pip \
    python3-nose \
    python3-numpy \
    python3-scipy \
    emacs24-nox \
    libhdf5-serial-dev \
    libboost-all-dev \
    htop \
    cmake

pip install \
    awscli \
    boto3 \
    pytest \
    pytest-cov \
    pytest-xdist \
    cython \
    h5py

pip3 install \
    awscli \
    boto3 \
    pytest \
    pytest-cov \
    pytest-xdist \
    cython \
    h5py

# This will actually install X, gnome, etc. It may seem like a lot, but if you
#
# $ sudo apt-get install -y debtree
# $ debtree cuda --no-recommends --no-alternatives --max-depth=7 | dot -Tpng -o cuda.png
#
# and look at the dependency graph, you'll see that
#
#   cuda-drivers -> nvidia-352 -> xserver-xorg-core
#
# among other things.

dpkg -i `find packages -name "*.deb"`
apt-get update -y
apt-get install -y cuda 

if [ ! -e archives/cudnn-7.0-linux-x64-v4.0-prod.tgz ] ; then
    echo 'Download the cudnn archive from developer.download.nvidia.com.'
    echo 'You will need to sign up as a developer and answer a few questions.'
    echo 'The file name will be something like cudnn-7.0-linux-x64-v4.0-prod.tgz.'
    echo 'Copy it to the archives/ directory.'

    exit 1
fi

(cd build;
    tar xfz ../archives/cudnn-7.0-linux-x64-v4.0-prod.tgz)

cp build/cuda/lib64/* /usr/local/cuda/lib64/
cp build/cuda/include/cudnn.h /usr/local/cuda/include

if [ ! -e /etc/profile.d/cuda.sh ]; then
    cat >> /etc/profile.d/cuda.sh <<EOF
#! /bin/sh
export CUDA_ROOT="/usr/local/cuda"
export CUDA_HOME="\$CUDA_ROOT"
export CUDA_INC_DIR="\$CUDA_ROOT/include"
export LD_LIBRARY_PATH="\$CUDA_ROOT/lib64:\$LD_LIBRARY_PATH"
export PATH="\$PATH:\$CUDA_ROOT/bin"

EOF
fi

echo 'Run stage2.sh to set up .theanorc, and to clone the cnmem, theano, and keras repos.'
