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
    
