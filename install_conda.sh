#!/bin/bash

set -ex

export CONDA_DIR=~/anaconda

# Check if CONDA_DIR directory exists
if [ -d "$CONDA_DIR" ]
then
    echo "Directory $CONDA_DIR exists. Removing."
    rm -rf $CONDA_DIR
else
    echo "Directory $CONDA_DIR does not exist."
fi

cd /tmp

wget https://repo.anaconda.com/archive/Anaconda3-2021.11-Linux-x86_64.sh -O ~/anaconda.sh

chmod +x ~/anaconda.sh

~/anaconda.sh -b -p $HOME/anaconda

cat <<EOF | tee -a /home/demouser/.bashrc
export PATH="/home/demouser/anaconda/bin:$PATH"
EOF

source ~/.bashrc
