#!/bin/bash

script_dir=$(readlink -f $(dirname $0))
host_ip=`/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`

container_name="codesubmit"
worker_dir=/tmp/codesubmit/worker/
host_shared_dir=$(readlink -f "$script_dir/../../../")
argument="--livereload-admin=35728 --livereload-student=35727 all"

mkdir -p $worker_dir

docker build -t ${USER}:$container_name $script_dir
docker kill $container_name
docker rm $container_name

/bin/bash $script_dir/../mongodb/mongodb_up.sh
/bin/bash $script_dir/../redis/redis_up.sh
/bin/bash $script_dir/../rabbitmq/rabbitmq_up.sh

sandboxrun=tomlau10/sandbox-run
if [ -z "$(docker images -a | grep $sandboxrun)" ]; then
    echo "$sandboxrun docker image exists, pulling..."
    docker pull $sandboxrun
else
    echo "$sandboxrun docker image exists, skip pulling."
fi

echo "shared_dir:" $host_shared_dir
echo "container_name:" $container_name
echo "host_ip": $host_ip
echo "argument": $argument

docker run  -i \
			-u $(id -u):$(getent group docker | cut -d: -f3) \
			-e "host_ip="$host_ip \
			-p 8000:8000 \
			-p 8001:8001 \
			-p 35728:35728 \
			-p 35727:35727 \
			-v $host_shared_dir:/host_shared \
			-v $worker_dir:$worker_dir \
			-v /var/run/docker.sock:/var/run/docker.sock \
			-v $(which docker):/bin/docker \
			-v /usr/lib/x86_64-linux-gnu/libapparmor.so.1.1.0:/lib/x86_64-linux-gnu/libapparmor.so.1 \
			--name $container_name \
			${USER}:$container_name \
			$argument
