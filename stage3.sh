#! /bin/bash

set -e
# Any subsequent(*) commands which fail will cause the shell script to exit immediately

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Run this script as root."
    exit
fi

(cd build/pycuda-2016.1/ ;
    make install)

(cd repos/cnmem/build ;
    make install)

(cd repos/Theano ;
    pip install --upgrade --no-deps . ;
    pip3 install --upgrade --no-deps . )

(cd repos/keras ;
    pip install --upgrade --no-deps . ;
    pip3 install --upgrade --no-deps . )
