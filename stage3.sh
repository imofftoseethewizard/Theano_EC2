#! /bin/bash

set -e
# Any subsequent(*) commands which fail will cause the shell script to exit immediately

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Run this script as root."
    exit
fi

pushd build/pycuda-2016.1/
make install
popd

cd repos

pushd Theano
pip install --upgrade --no-deps .
pip3 install --upgrade --no-deps .
popd

pushd keras
pip install --upgrade --no-deps .
pip3 install --upgrade --no-deps .
popd
