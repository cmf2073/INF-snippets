#!/bin/bash

docker tag redmine:latest redmine:rollback

#docker pull redmine
docker build -t redmine:latest ./lsm-INF-001-redmine

docker stop redmine-v1
docker rm redmine-v1

docker run --name=redmine-v1 -d -p 3000:3000 -v /var/apps/jenkins_local:/var/jenkins_home --restart=always --log-driver=awslogs --log-opt awslogs-region=us-west-2 --log-opt awslogs-group=lsm-INF-logs --log-opt awslogs-stream=lsm-INF-001-redmine redmine:latest
