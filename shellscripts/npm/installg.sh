#!/bin/bash

script_dir=$(readlink -f $(dirname $0))

sudo apt-get -y install build-essential git curl libkrb5-dev

curl -sSL https://get.docker.com/ | sh
sudo usermod -aG docker ${USER}

curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
sudo apt-get install -y nodejs

sudo npm install -g node-gyp \
	grunt-cli \
	coffee-script

cd $(readlink -f "$script_dir/../../")

npm install
grunt html

chmod +x -R shellscripts/
