# Amazon EC2 Theano instance #

Script to run on an Amazon EC2 instance with a GPU to set up keras backed by Theano and Tensorflow.


## Startup an Amazon EC2 instance ##

Search for the 
[*Amazon Linux x64 AMI with TensorFlow (GPU)*](https://aws.amazon.com/marketplace/pp/B01AOE205O)
AMI by Altoros in the AWS marketplace.
Launch one of these AMIs on a GPU instance (e.g. *g2.2xlarge*).

## Install Theano and Keras ##

SSH into the shell of the newly created instance, and install git via:

    sudo yum -y install git

Get the setup script by running:

    git clone https://github.com/imofftoseethewizard/keras_EC2.git

And run this script via:

    cd ./keras_EC2/ && sudo sh setup.sh

## Test Theano ##

Create the cuda device drivers by running the startup script (not required on the Altoros AMI):

    sudo sh cuda_startup.sh

Test the Theano installation by running:

    sh test_theano.sh
