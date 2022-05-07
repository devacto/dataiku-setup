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

cd /home/demouser

export VERSION=10.0.5
export INSTALLER_NAME=dataiku-dss-$VERSION
export DATA_DIR=$INSTALLER_NAME-data
export PORT=10000

# Check if DATA_DIR directory exists
if [ -d "$DATA_DIR" ]
then
    echo "Directory $DATA_DIR exists. Removing."
    rm -r $DATA_DIR
else
    echo "Directory $DATA_DIR does not exists."
fi

# Check if DSS directory exists
if [ -d "$INSTALLER_NAME" ]
then
    echo "Directory $INSTALLER_NAME exists. Removing."
    rm -r $INSTALLER_NAME
else
    echo "Directory $INSTALLER_NAME does not exists."
fi

# Check if DSS installer file exists
if [ -f "$INSTALLER_NAME.tar.gz" ]
then
    echo "File $INSTALLER_NAME.tar.gz exists. Removing."
    rm -r $INSTALLER_NAME.tar.gz
else
    echo "Directory $INSTALLER_NAME does not exists."
fi

wget https://cdn.downloads.dataiku.com/public/dss/$VERSION/$INSTALLER_NAME.tar.gz

tar xzf $INSTALLER_NAME.tar.gz

# Install Dataiku DSS
$INSTALLER_NAME/installer.sh -y -d $DATA_DIR -p $PORT -l license.json

$DATA_DIR/bin/start
