script_dir=$(readlink -f $(dirname $0))
default_container_name="mongodb"
default_host_shared_dir="$HOME/$default_container_name"
backup_suffix="_backup"
default_mapped_host_port=27017
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

host_shared_backup_dir=$host_shared_dir$backup_suffix
docker build -t ${USER}:$container_name $script_dir
docker kill $container_name
docker rm $container_name
echo "shared_dir:" $host_shared_dir
echo "shared_backup_dir:" $host_shared_backup_dir
echo "container_name:" $container_name
echo "mapped_host_port:" $mapped_host_port
echo "host_ip": $host_ip
echo "argument": $argument
docker run -d -p $mapped_host_port:27017 -v $host_shared_dir:/data/db -v $host_shared_backup_dir:/backup --name $container_name ${USER}:$container_name $argument
