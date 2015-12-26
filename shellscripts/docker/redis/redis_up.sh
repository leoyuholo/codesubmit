#!/bin/bash

script_dir=$(readlink -f $(dirname $0))

container_name="redis"
argument=""

docker build -t ${USER}:$container_name $script_dir
docker kill $container_name
docker rm $container_name

docker run -d \
	-p 6379:6379 \
	-v $HOME/redis:/data \
	--name $container_name \
	${USER}:$container_name \
	$argument
