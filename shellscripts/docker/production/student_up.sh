script_dir=$(readlink -f $(dirname $0))
default_container_name="codesubmitstudent"
default_host_shared_dir=$(readlink -f "$script_dir/../../../")
default_mapped_host_port=80
default_argument="/host_shared/student/server/app.coffee"
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

docker run  -d \
			-u $(id -u):$(id -g) \
			-p $mapped_host_port:8001 \
			-v $host_shared_dir:/host_shared \
			--restart="always" \
			--name $container_name \
			${USER}:$container_name \
			$argument
