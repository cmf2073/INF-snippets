#!/bin/bash

docker tag nagios-core-4.x-v2:latest nagios-core-4.x-v2:rollback

docker build -t nagios-core-4.x-v2:latest ./lsm-INF-dckr-nagios-core-4.x-v2

docker stop lsm-INF-dckr-nagios-core-4.x-v2
docker rm lsm-INF-dckr-nagios-core-4.x-v2

docker run --name=lsm-INF-dckr-nagios-core-4.x-v2 -d -p 8026:25 -p 8081:80 --cpu-period=50000 --cpu-quota=25000 --restart=always --log-driver=awslogs --log-opt awslogs-region=us-west-2 --log-opt awslogs-group=lsm-INF-logs --log-opt awslogs-stream=lsm-INF-dckr-nagios-core-4.x-v2 nagios-core-4.x-v2:latest
