script_dir=$(readlink -f $(dirname $0))
default_container_name="codesubmitworker"
default_host_shared_dir=$(readlink -f "$script_dir/../../../")
default_mapped_host_port=8002
default_argument="worker"
host_ip=`/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`

if [ "$1" == "--help" ]
then
	echo "usage: $0 host_shared_dir container_name mapped_host_port argument"
	exit
fi

host_shared_dir=$([ "$1" == "" ] && echo $default_host_shared_dir || echo $(readlink -f $1))
container_name=$([ "$2" == "" ] && echo $default_container_name || echo "$2")
mapped_host_port=$([ "$3" == "" ] && echo $default_mapped_host_port || echo "$3")
argument=$([ "$4" == "" ] && echo $default_argument || echo "$4")

docker build -t ${USER}:$container_name $script_dir
docker kill $container_name
docker rm $container_name

echo "shared_dir:" $host_shared_dir
echo "container_name:" $container_name
echo "mapped_host_port:" $mapped_host_port
echo "host_ip": $host_ip
echo "argument": $argument

sandboxrun=tomlau10/sandbox-run
if [ -z "$(docker images -a | grep $sandboxrun)" ]; then
	echo "$sandboxrun docker image exists, pulling..."
	docker pull $sandboxrun
else
	echo "$sandboxrun docker image exists, skip pulling."
fi
docker run  -i \
			-e "host_ip="$host_ip \
			-p $mapped_host_port:8002 \
			-v $host_shared_dir:/host_shared \
			-v /codesubmit/worker/:/codesubmit/worker/ \
			-v /var/run/docker.sock:/var/run/docker.sock \
			-v $(which docker):/bin/docker \
			-v /usr/lib/x86_64-linux-gnu/libapparmor.so.1.1.0:/lib/x86_64-linux-gnu/libapparmor.so.1 \
			--name $container_name \
			${USER}:$container_name \
			$argument
