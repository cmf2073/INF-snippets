#!/bin/bash

docker tag nagios-core-4.x:latest nagios-core-4.x:rollback

docker build -t nagios-core-4.x:latest ./lsm-INF-dckr-nagios-core-4.x

docker stop lsm-INF-dckr-nagios-core-4.x
docker rm lsm-INF-dckr-nagios-core-4.x

docker run --name=lsm-INF-dckr-nagios-core-4.x -d -p 8025:25 -p 8080:80 --cpu-period=50000 --cpu-quota=25000 --restart=always --log-driver=awslogs --log-opt awslogs-region=us-west-2 --log-opt awslogs-group=lsm-INF-logs --log-opt awslogs-stream=lsm-INF-dckr-nagios-core-4.x nagios-core-4.x:latest
