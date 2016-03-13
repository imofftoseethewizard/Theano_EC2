#! /bin/bash

set -e
# Any subsequent(*) commands which fail will cause the shell script to exit immediately

if [[ $(/usr/bin/id -u) -eq 0 ]]; then
    echo "Do not run this script as root."
    exit
fi

if fgrep --quiet "# Added by keras_EC2 stage1.sh >>>>" ~/.profile; then
    echo '.profile not changed, verify that PATH and LD_LIBRARY_PATH include /usr/local/cuda/{bin,lib64}, respectively.'
else
    cat >> ~/.profile <<EOF

# Added by keras_EC2 stage1.sh >>>>

export CUDA_ROOT=/usr/local/cuda
export CUDA_HOME=\$CUDA_ROOT
export CUDA_INC_DIR=\$CUDA_ROOT/include
export LD_LIBRARY_PATH=\$CUDA_ROOT/lib64:\$LD_LIBRARY_PATH
export PATH=\$PATH:\$CUDA_ROOT/bin


# ^^^^ Added by keras_EC2 stage1.sh

EOF
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
    [mode]=FAST_RUN

[nvcc]
    fastmath=True

[cuda]
    root=/usr/local/cuda"

# ^^^^ Added by keras_EC2 stage1.sh

EOF

fi

pushd repos
rm -rf keras Theano
git clone git@github.com:fchollet/keras.git
git clone git@github.com:Theano/Theano.git
popd

#ensure $CUDA_ROOT/bin is in the path, required to build pycuda
source .profile 

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
popd

pushd build/pycuda-2016.1/
python configure.py
make 2>/dev/null
popd

echo 'Reboot and run stage3.sh as root install pycuda, Theano, and keras.'
