#!/bin/bash

docker build -t apache2-claroviajes.com:latest ./lsm-INF-dckr-apache2-claroviajes.com


docker stop lsm-INF-dckr-apache2-claroviajes.com
docker rm lsm-INF-dckr-apache2-claroviajes.com


docker run --name=lsm-INF-dckr-apache2-claroviajes.com -d -p 80:80 -p 443:443 --restart=always --log-driver=awslogs --log-opt awslogs-region=us-west-2 --log-opt awslogs-group=lsm-INF-logs --log-opt awslogs-stream=lsm-INF-dckr-apache2-claroviajes.com apache2-claroviajes.com:latest


# Model
#------
#docker build -t nginx-z0:latest ./nginx-z0

#docker stop nginx-z0
#docker rm nginx-z0

#docker run -d -p 80:80 -p 443:443 --restart=always --name=nginx-z0 nginx-z0:latest
