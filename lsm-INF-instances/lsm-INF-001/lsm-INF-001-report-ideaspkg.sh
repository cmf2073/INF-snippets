#!/bin/bash

docker tag lsm-report-ideaspkg-v1:latest lsm-report-ideaspkg-v1:rollback

docker build -t lsm-report-ideaspkg-v1:latest ./lsm-INF-001-report-ideaspkg

docker stop lsm-report-ideaspkg-v1
docker rm lsm-report-ideaspkg-v1

docker run --name=lsm-report-ideaspkg-v1 -d \
-m 375M --cpu-period=50000 --cpu-quota=25000 \
-p 2222:22 \
-v /var/apps/IdeasPkg_root:/usr/local/ideaspkg_root \
--env='GitUser=carlos.farina@claroviajes.com' \
--env='GitAccKey=Carlos2014' \
--restart=always \
--log-driver=awslogs --log-opt awslogs-region=sa-east-1 --log-opt awslogs-group=latam-INF --log-opt awslogs-stream=lsm-INF-001-report-ideaspkg \
lsm-report-ideaspkg-v1:latest

# -p 8026:25 -p 8081:80 --cpu-period=50000 --cpu-quota=25000 \
#--env='DB_USER=redmineAPP' \
#--env='DB_USER=redmineAPP' \
#--env='DB_USER=redmineAPP' \
#--env='DB_USER=redmineAPP' \

