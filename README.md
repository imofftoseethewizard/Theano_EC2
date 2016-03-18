# Amazon EC2 keras/Theano instance #

Script to run on an Amazon EC2 instance with a GPU to set up keras backed by Theano.
The scripts started with Markus Beissinger's post 
[How to install Theano on Amazon EC2 GPU instances for deep learning]
(http://markus.com/install-theano-on-aws/) and then took some stuff from
Berkeley Vision and Learning Center's wiki
[Install Caffe on AWS from scratch]
(https://github.com/BVLC/caffe/wiki/Install-Caffe-on-EC2-from-scratch-(Ubuntu,-CUDA-7,-cuDNN)).
In addtion there were a lot of random bits [stack overflow](http://stackoverflow.com). You should
be able to run keras in both Python 2.7 and Python 3.4 after completing these steps.

## Launch Instance ##

Launch the default Ubuntu 14.04 AMI
[*Ubuntu Server 14.04 LTS (HVM), SSD Volume Type - ami-9abea4fb*]
(https://aws.amazon.com/marketplace/pp/B00JV9TBA6/ref=mkt_wir_Ubuntu14)
on a GPU instance (e.g. *g2.2xlarge*).

## Installation

SSH into the newly created instance, and install git via

    sudo apt-get -y install git

Get the setup scripts by running

    git clone https://github.com/imofftoseethewizard/ubuntu-keras.git

Get the latest cudnn archive from Nvidia. You'll need to sign up as a developer for this.
Then copy it to the archives subdirectory of this project

     scp cudnn-7.0-linux-x64-v4.0-prod.tgz ubuntu@<instance>:ubuntu-keras/archives

Start by installing some standard packages with apt-get and pip in addition to the latest
cuda packages from Nvidia. This takes about 15 minutes.

    cd ubuntu-keras
    sudo ./stage1.sh

Next configure your .profile and .theanorc files, clone the Theano and keras repos,
and build pycuda.

    ./stage2.sh

Now install pycuda, Theano, and keras

    sudo ./stage3.sh

At this point, you can snapshot the instance and create an AMI. These scripts are idempotent,
so you can re-run them at any time to update.

## Testing

To test the installation,

    cd ubuntu-keras/repos
    py.test

To test keras on the CPU, change your .theanorc file, and alter ubuntu-keras/repos/keras/pytest.ini
so that the line
"-n 2" is "-n <cores on your machine>". If you want to test on the GPU, make sure your
.theanorc file specifies the GPU and remove the "-n" line from pytest.ini. It seems not to
work very well when there are multiple processes trying to access the GPU at the same time.