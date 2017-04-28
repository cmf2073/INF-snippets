#!/bin/bash

#docker tag lsm-report-ideaspkg-v1:latest lsm-report-ideaspkg-v1:rollback

#docker build -t lsm-report-ideaspkg-v1:latest ./lsm-INF-001-report-ideaspkg

#docker stop lsm-report-ideaspkg-v3
#docker rm lsm-report-ideaspkg-v3

docker run --name=lsm-report-pump-v1 -d \
-m 375M --cpu-period=50000 --cpu-quota=25000 \
-p 2223:22 \
lsm-report-ideaspkg-v1:latest

