#!/bin/bash

docker tag jenkins jenkins-ver1:rollback

docker pull jenkins
#docker build -t nagios-core-4.x:latest ./lsm-INF-dckr-nagios-core-4.x

docker stop jenkins-ver1
docker rm jenkins-ver1

docker run --name=jenkins-ver1 -d -p 8010:8080 -p 50000:50000 -v /var/apps/jenkins_local:/var/jenkins_home --restart=always --log-driver=awslogs --log-opt awslogs-region=us-west-2 --log-opt awslogs-group=lsm-INF-logs --log-opt awslogs-stream=lsm-INF-dckr-jenkins-ver1 jenkins
