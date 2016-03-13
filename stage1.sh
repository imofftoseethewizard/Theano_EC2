
# fetch the ubuntu package definitions from nvidia, for example
#   cd downloads
#   wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1404/x86_64/cuda-repo-ubuntu1404_7.5-18_amd64.deb
# 
dpkg downloads/*.deb
apt-get update
apt-get install -y cuda 

cd build
tar xfz ../archives/*.gz
cd cuda
cp lib64/* /usr/local/cuda/lib64/
cp include/cudnn.h /usr/local/cuda/include

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

echo 'Reboot your system and run stage2.sh'
