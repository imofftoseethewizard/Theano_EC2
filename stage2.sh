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

cd repos
rm -rf keras Theano
git clone git@github.com:fchollet/keras.git
git clone git@github.com:Theano/Theano.git

echo 'Reboot and run stage3.sh to install build pycuda.'
echo 'Stage 3 produces a lot of compiler warnings. That seems to be normal.'
