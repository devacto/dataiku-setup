#!/bin/bash

set -ex

# Delete existing Docker packages if there are any.
packages=( "docker" \
           "docker-client" \
           "docker-client-latest" \
           "docker-common" \
           "docker-latest" \
           "docker-latest-logrotate" \
           "docker-logrotate" \
           "docker-engine" \
         )

for p in "${packages[@]}"
do
  if [ -x "$(yum list installed $p)" ]; then
    echo "--- $p already installed. removing. ---"
    sudo yum -y remove $p
  fi
done

# Install yum-utils
if ! [ -x "$(yum list installed yum-utils)" ]; then
  echo "--- installing yum-utils ---"
  sudo yum -y install yum-utils
else
  echo "--- yum-utils already installed --- "
fi

sudo yum-config-manager \
    --add-repo https://download.docker.com/linux/centos/docker-ce.repo


# Install Docker
dpackages=( "docker-ce" \
            "docker-ce-cli" \
            "containerd.io" \
            "docker-compose-plugin" \
          )

for d in "${dpackages[@]}"
do
  if ! [ -x "$(yum list installed $d)" ]; then
    echo "--- installing $d ---"
    sudo yum -y install $d
  else
    echo "--- $d already installed --- "
  fi
done

sudo systemctl start docker

gcloud auth configure-docker -q
