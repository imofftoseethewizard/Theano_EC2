#! /bin/bash

set -e
# Any subsequent(*) commands which fail will cause the shell script to exit immediately

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Run this script as root."
    exit
fi

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

dpkg -i `ls packages`
apt-get update
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

echo 'Run stage2.sh to set up .profile and .theanorc, and to clone the theano and keras repos.'
