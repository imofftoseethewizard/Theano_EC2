FROM ubuntu:latest

RUN (apt-get install -y git && \
     git clone https://github.com/imofftoseethewizard/ubuntu-keras.git /usr/src/ubuntu-keras)
     
ADD cudnn-7.0-linux-x64-v4.0-prod.tgz /usr/src/ubuntu-keras/archive

RUN (cd /usr/src/ubuntu-keras && ./stage1.sh && ./stage2.sh && stage3.sh)

