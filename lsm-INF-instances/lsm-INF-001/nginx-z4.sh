#!/bin/bash

docker tag nginx-z4:latest nginx-z4:rollback

docker build -t nginx-z4:latest ./nginx-z4

docker stop nginx-z4
docker rm nginx-z4

docker run -d -p 80:80 -p 443:443 --log-driver=awslogs --log-opt awslogs-region=us-west-2 --log-opt awslogs-group=pushtravel-z4 --log-opt awslogs-stream=pushtravel-nginx-z4  --restart=always --name=nginx-z4 nginx-z4:latest

### original line - before moving
#docker run -d -p 80:80 -p 443:443 --log-driver=awslogs --log-opt awslogs-region=sa-east-1 --log-opt awslogs-group=pushtravel-z4 --log-opt awslogs-stream=pushtravel-nginx-z4  --restart=always --name=nginx-z4 nginx-z4:latest

### model line
#docker run -d -p 172.31.23.171:80:80 -p 172.31.23.171:443:443 --log-driver=awslogs --log-opt awslogs-region=sa-east-1 --log-opt awslogs-group=pushtravel-latam --log-opt awslogs-stream=pushtravel-nginx-z1 --restart=always --name=nginx-z1 nginx-z1:latest
