#!/bin/bash

docker build -t nagios-core-4.x:latest ./lsm-INF-dckr-nagios-core-4.x


docker stop lsm-INF-dckr-nagios-core-4.x
docker rm lsm-INF-dckr-nagios-core-4.x


docker run --name=lsm-INF-dckr-nagios-core-4.x -d -p 25:25 -p 80:80 --restart=always --log-driver=awslogs --log-opt awslogs-region=us-west-2 --log-opt awslogs-group=lsm-INF-logs --log-opt awslogs-stream=lsm-INF-dckr-nagios-core-4.x nagios-core-4.x:latest





# Model
#------
#docker build -t nginx-z0:latest ./nginx-z0

#docker stop nginx-z0
#docker rm nginx-z0

#docker run -d -p 80:80 -p 443:443 --restart=always --name=nginx-z0 nginx-z0:latest
