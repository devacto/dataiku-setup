#!/bin/bash

set -ex

# Install kubectl
if ! [ -x "$(yum list installed kubectl)" ]; then
  echo "--- installing kubectl ---"
  sudo yum -y install kubectl
else
  echo "--- kubectl already installed --- "
fi
