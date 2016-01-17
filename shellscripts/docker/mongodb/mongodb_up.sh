#!/bin/bash

script_dir=$(readlink -f $(dirname $0))

container_name="mongodb"
argument=""

AWS_ACCESS_KEY=""
AWS_SECRET_KEY=""
S3_REGION=""
S3_BUCKET=""

docker build -t ${USER}:$container_name $script_dir
docker kill $container_name
docker rm $container_name

docker run -d \
	-p 27017:27017 \
	-e AWS_ACCESS_KEY=$AWS_ACCESS_KEY \
	-e AWS_SECRET_KEY=$AWS_SECRET_KEY \
	-e S3_REGION=$S3_REGION \
	-e S3_BUCKET=$S3_BUCKET \
	-v $HOME/mongodb:/data/db \
	-v $HOME/mongodb_backup:/backup \
	-v $script_dir/mongodb-s3-backup.sh:/mongodb-s3-backup.sh \
	--name $container_name \
	${USER}:$container_name \
	$argument
