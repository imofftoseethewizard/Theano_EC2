apt-get update
apt-get -y dist-upgrade
sudo apt-get install -y \
    gcc \
    g++ \
    gfortran \
    build-essential \
    git \
    wget \
    linux-image-generic \
    libopenblas-dev \
    python-dev \
    python-pip \
    python-nose \
    python-numpy \
    python-scipy \
    emacs24-nox \
    libhdf5-serial-dev \
    libboost-all-dev \
    htop \
    cmake

sudo pip install \
    pytest \
    pytest-cov \
    pytest-xdist \
    cython \
    hd5py
    
