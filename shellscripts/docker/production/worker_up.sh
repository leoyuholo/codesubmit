#!/bin/bash

script_dir=$(readlink -f $(dirname $0))
host_ip=`/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`

container_name="codesubmitworker"
worker_dir=/tmp/codesubmit/worker/
host_shared_dir=$(readlink -f "$script_dir/../../../")
argument="/host_shared/worker/server/app.coffee"

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
echo "master_ip": $master_ip
echo "argument": $argument

sandboxrun=tomlau10/sandbox-run
if [ -z "$(docker images -a | grep $sandboxrun)" ]; then
	echo "$sandboxrun docker image does not exist, pulling..."
	docker pull $sandboxrun
else
	echo "$sandboxrun docker image exists, skip pulling."
fi

docker run  -d \
			-e NODE_ENV=production \
			-u $(id -u):$(getent group docker | cut -d: -f3) \
			-e "HOST_IP="$master_ip \
			-v $host_shared_dir:/host_shared \
			-v $worker_dir:$worker_dir \
			-v /var/run/docker.sock:/var/run/docker.sock \
			-v $(which docker):/bin/docker \
			-v /usr/lib/x86_64-linux-gnu/libapparmor.so.1.1.0:/lib/x86_64-linux-gnu/libapparmor.so.1 \
			--restart="always" \
			--name $container_name \
			${USER}:$container_name \
			$argument
