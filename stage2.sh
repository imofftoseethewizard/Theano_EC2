#! /bin/bash

set -e
# Any subsequent(*) commands which fail will cause the shell script to exit immediately

if [[ $(/usr/bin/id -u) -eq 0 ]]; then
    echo "Do not run this script as root."
    exit
fi

touch ~/.theanorc

if fgrep --quiet "# Added by keras_EC2 stage1.sh >>>>" ~/.theanorc; then
    echo '.theanorc not changed.'
else
    cat >> ~/.theanorc <<EOF
# Added by keras_EC2 stage1.sh >>>>

[global]
floatX=float32
device=gpu
mode=FAST_RUN

[nvcc]
fastmath=True

[cuda]
root=/usr/local/cuda

# ^^^^ Added by keras_EC2 stage1.sh

EOF

fi

pushd repos

if [ ! -d cnmem ] ; then
    git clone https://github.com/NVIDIA/cnmem.git
else
    pushd cnmem
    git checkout master
    git pull
    popd
fi

if [ ! -d keras ] ; then
    git clone https://github.com/fchollet/keras.git
else
    pushd keras
    git checkout master
    git pull
    popd
fi

if [ ! -d Theano ] ; then
    git clone https://github.com/Theano/Theano.git
else
    pushd Theano
    git checkout master
    git pull
    popd
fi

popd

# ensure $CUDA_ROOT/bin is in the path, required to build pycuda.
# CUDA_HOME and LD_LIBRARY_PATH are required for building cnmem
source ~/.profile 

pushd repos/cnmem
mkdir -p build
cd build
cmake ..
make
popd 

pushd archives
rm -f pycuda*
wget https://pypi.python.org/packages/source/p/pycuda/pycuda-2016.1.tar.gz#md5=96e50fd4b079d4f6e8bd1bd2207ca48d
md5=`md5sum pycuda-2016.1.tar.gz | awk '{ print $1 }'`

if [ $md5 != "96e50fd4b079d4f6e8bd1bd2207ca48d" ] ; then
    echo 'Pycuda archive checksum does not match'.

    exit 1
fi
popd

pushd build
tar xfz ../archives/pycuda-2016.1.tar.gz

cd pycuda-2016.1/
python configure.py
make 2>/dev/null
popd

echo 'Reboot and run stage3.sh as root install pycuda, Theano, and keras.'
