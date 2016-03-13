#! /bin/bash

if fgrep --quiet "# Added by keras_EC2 stage1.sh >>>>" ~/.profile; then
    echo '.profile not changed, verify that PATH and LD_LIBRARY_PATH include /usr/local/cuda/{bin,lib64}, respectively.'
else
    cat >> ~/.profile <<EOF

# Added by keras_EC2 stage1.sh >>>>

export CUDA_HOME=/usr/local/cuda
export CUDA_ROOT=$CUDA_HOME
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH
export PATH=$PATH:$CUDO_HOME/bin

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

echo 'Reboot and run stage3.sh to install pycuda, theano, and keras.'
