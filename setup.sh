#!/bin/bash

# update yum
sudo yum -y update

# install gcc compilers
sudo yum -y groupinstall "Development tools"

# install numerical libraries
sudo yum -y install \
	blas-devel \
	lapack-devel \
	atlas-devel
# install python libraries
# http://www.scipy.org/install.html
sudo yum -y install \
	python-devel \
	python-setuptools \
	python-pip

# install theano
sudo pip install nose
sudo pip install git+git://github.com/Theano/Theano.git



