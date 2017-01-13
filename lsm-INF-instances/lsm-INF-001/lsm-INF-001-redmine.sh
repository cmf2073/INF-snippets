#!/bin/bash

docker tag redmine:latest redmine:rollback

#docker pull redmine
docker build -t redmine:latest ./lsm-INF-001-redmine

docker stop redmine-v2
docker rm redmine-v2

docker run --name=redmine-v2 -d -p 80:3000 -p 8082:3000 \
--link mysql-engine:RedmineMysqlEngine \
-v /var/apps2/redmine_vol/root/files:/usr/src/redmine/files \
--env='DB_ADAPTER=mysql2' \
--env='DB_HOST=RedmineMysqlEngine' \
--env='DB_PORT=3306' \
--env='DB_NAME=redmine_prd' \
--env='DB_USER=redmineAPP' \
--env='DB_PASS=redminePass123qweasd' \
--env='REDMINE_PORT=8083' \
--restart=always \
--log-driver=awslogs --log-opt awslogs-region=us-west-2 --log-opt awslogs-group=lsm-INF-logs --log-opt awslogs-stream=lsm-INF-001-redmine \
redmine:latest
