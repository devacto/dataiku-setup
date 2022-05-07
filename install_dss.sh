#!/bin/bash

set -ex

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
    echo "Directory $DATA_DIR does not exist."
fi

# Check if DSS directory exists
if [ -d "$INSTALLER_NAME" ]
then
    echo "Directory $INSTALLER_NAME exists. Removing."
    rm -r $INSTALLER_NAME
else
    echo "Directory $INSTALLER_NAME does not exist."
fi

# Check if DSS installer file exists
if [ -f "$INSTALLER_NAME.tar.gz" ]
then
    echo "File $INSTALLER_NAME.tar.gz exists. Removing."
    rm -r $INSTALLER_NAME.tar.gz
else
    echo "Directory $INSTALLER_NAME does not exist."
fi

wget https://cdn.downloads.dataiku.com/public/dss/$VERSION/$INSTALLER_NAME.tar.gz

tar xzf $INSTALLER_NAME.tar.gz

# Install Dataiku DSS
$INSTALLER_NAME/installer.sh -y -d $DATA_DIR -p $PORT -l license.json

$DATA_DIR/bin/dss start

sudo -i "/home/demouser/$INSTALLER_NAME/scripts/install/install-boot.sh" \
  "/home/demouser/$DATA_DIR" demouser
