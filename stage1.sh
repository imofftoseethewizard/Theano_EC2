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
    pytest \
    pytest-cov \
    pytest-xdist \
    cython \
    h5py

pip3 install \
    pytest \
    pytest-cov \
    pytest-xdist \
    cython \
    h5py

cd packages
rm *
wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1404/x86_64/cuda-repo-ubuntu1404_7.5-18_amd64.deb
dpkg -i packages/*.deb
apt-get update
apt-get install -y cuda 

if [ ! -e archives/cudnn-7.0-linux-x64-v4.0-prod.tgz ] ; then
    echo 'Download the cudnn archive from developer.download.nvidia.com.'
    echo 'You will need to sign up as a developer and answer a few questions.'
    echo 'The file name will be something like cudnn-7.0-linux-x64-v4.0-prod.tgz.'
    echo 'Copy it to the archives/ directory.'

    exit 1
fi

cd build
tar xfz ../archives/cudnn-7.0-linux-x64-v4.0-prod.tgz
cd cuda
cp lib64/* /usr/local/cuda/lib64/
cp include/cudnn.h /usr/local/cuda/include

echo 'Run stage2.sh to set up .profile and .theanorc, and to clone the theano and keras repos.'
