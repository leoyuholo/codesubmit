script_dir=$(readlink -f $(dirname $0))
default_container_name="rabbitmq"
default_host_shared_dir="$HOME/$default_container_name"
default_mapped_host_port=5672
default_argument=""
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

mapped_host_management_port=1$mapped_host_port
docker build -t ${USER}:$container_name $script_dir
docker kill $container_name
docker rm $container_name
echo "shared_dir:" $host_shared_dir
echo "container_name:" $container_name
echo "mapped_host_port:" $mapped_host_port
echo "mapped_host_management_port:" $mapped_host_management_port
echo "host_ip": $host_ip
echo "argument": $argument
echo "default login": guest / guest
docker run -d \
	-p $mapped_host_port:5672 \
	-p $mapped_host_management_port:15672 \
	-v $host_shared_dir:/var/lib/rabbitmq \
	--name $container_name \
	${USER}:$container_name \
	$argument
