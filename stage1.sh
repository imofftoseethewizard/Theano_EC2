#! /bin/bash

# fetch the ubuntu package definitions from nvidia, for example
#   cd packages
#   wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1404/x86_64/cuda-repo-ubuntu1404_7.5-18_amd64.deb
# 

dpkg -i packages/*.deb
apt-get update
apt-get install -y cuda 


# Download the cudnn archive from developer.download.nvidia.com.
# You will need to sign up as a developer and answer a few questions.
# The file name will be something like cudnn-7.0-linux-x64-v4.0-prod.tgz.
# Copy it to the archives/ directory.
cd build
tar xfz ../archives/*tgz
cd cuda
cp lib64/* /usr/local/cuda/lib64/
cp include/cudnn.h /usr/local/cuda/include

echo 'Run stage2.sh to set up .profile and .theanorc.'
