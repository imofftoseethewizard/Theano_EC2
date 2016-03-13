#! /bin/bash

set -e
# Any subsequent(*) commands which fail will cause the shell script to exit immediately

if [[ $(/usr/bin/id -u) -eq 0 ]]; then
    echo "Do not run this script as root."
    exit
fi

cd archives
rm -f pycuda*
wget https://pypi.python.org/packages/source/p/pycuda/pycuda-2016.1.tar.gz#md5=96e50fd4b079d4f6e8bd1bd2207ca48d
md5=`md5sum pycuda-2016.1.tar.gz | awk '{ print $1 }'`

if [ $md5 != "96e50fd4b079d4f6e8bd1bd2207ca48d" ] ; then
    echo 'Pycuda archive checksum does not match'.

    exit 1
fi

cd ../build
tar xfz ../archives/pycuda-2016.1.tar.gz

cd pycuda-2016.1/
python configure.py
make 2>/dev/null
