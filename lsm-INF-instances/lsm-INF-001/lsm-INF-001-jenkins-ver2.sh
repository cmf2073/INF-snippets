#!/bin/bash

docker tag jenkins:latest jenkins-ver2:rollback

#docker pull jenkins
docker build -t jenkins:latest ./lsm-INF-001-jenkins-ver2

docker stop jenkins-v2
docker rm jenkins-v2

docker run --name=jenkins-v2 -d -p 8010:8080 -p 50000:50000 -v /var/apps/jenkins_local:/var/jenkins_home -v /var/apps/smt-start:/usr/bin/smt-start --restart=always --log-driver=awslogs --log-opt awslogs-region=us-west-2 --log-opt awslogs-group=lsm-INF-logs --log-opt awslogs-stream=lsm-INF-001-jenkins-ver2 jenkins:latest
