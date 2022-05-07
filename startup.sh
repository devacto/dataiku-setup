#!/bin/bash

set -ex

sudo yum -y update

# Install packages
packages=( "epel-release" \
           "centos-release-scl" \
           "rh-python38" \
           "expat" \
           "git" \
           "nginx" \
           "unzip" \
           "zip" \
           "java-1.8.0-openjdk" \
           "python" \
           "python3" \
           "freetype" \
           "libgfortran" \
           "libgomp" \
           "python2-devel" \
           "python36-devel" \
           "bzip2" \
           "mesa-libGL" \
           "libSM" \
           "libXrender" \
           "libgomp" \
           "alsa-lib" \
           "R-core-devel" \
           "libicu-devel" \
           "libcurl-devel" \
           "openssl-devel" \
           "libxml2-devel" \
           "wget" )

for p in "${packages[@]}"
do
  if ! [ -x "$(yum list installed $p)" ]; then
    echo "--- installing $p ---"
    sudo yum -y install $p
  else
    echo "--- $p already installed --- "
  fi
done

cd ~

export VERSION=10.0.2
export DATA_DIR=
export PORT=

# Check if DSS directory exists
if [ -d "~/" ]
then
    echo "Directory /path/to/dir exists."
else
    echo "Error: Directory /path/to/dir does not exists."
fi

# Check if DATA_DIR directory exists

wget https://cdn.downloads.dataiku.com/public/dss/$VERSION/dataiku-dss-$VERSION.tar.gz

tar xzf dataiku-dss-$VERSION.tar.gz
