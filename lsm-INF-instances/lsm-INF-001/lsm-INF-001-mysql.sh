#!/bin/bash

docker tag mysql:latest mysql-svr:rollback

#docker pull mysql
#docker build -t mysql:latest ./lsm-INF-001-mysql-svr

docker stop mysql-engine
docker rm mysql-engine


docker run --name=mysql-engine \
-d -p 3307:3306 \
-v /var/apps/MySQL-svr-datastore:/var/lib/mysql \
--restart=always \
--log-driver=awslogs --log-opt awslogs-region=us-west-2 --log-opt awslogs-group=lsm-INF-logs --log-opt awslogs-stream=lsm-INF-001-mysql-svr \
--env="MYSQL_ROOT_PASSWORD=testcmftest" \
mysql
