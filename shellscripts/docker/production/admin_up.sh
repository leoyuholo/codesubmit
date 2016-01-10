#!/bin/bash

script_dir=$(readlink -f $(dirname $0))
host_ip=`/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`

container_name="codesubmitadmin"
worker_dir=/tmp/codesubmit/worker/
host_shared_dir=$(readlink -f "$script_dir/../../../")
mapped_host_port=8000
argument="/host_shared/admin/server/app.coffee"

mkdir -p $worker_dir

if [ "$1" == "--help" ]
then
	echo "usage: $0 master_ip"
	exit
fi

master_ip=$([ "$1" == "" ] && echo $host_ip || echo "$1")

docker build -t ${USER}:$container_name $script_dir
docker kill $container_name
docker rm $container_name

echo "shared_dir:" $host_shared_dir
echo "container_name:" $container_name
echo "mapped_host_port:" $mapped_host_port
echo "host_ip": $host_ip
echo "argument": $argument

docker run  -d \
			-u $(id -u):$(getent group docker | cut -d: -f3) \
			-e "HOST_IP="$master_ip \
			-p 8000:8000 \
			-v $host_shared_dir:/host_shared \
			--restart="always" \
			--name $container_name \
			${USER}:$container_name \
			$argument
