#!/bin/bash

docker tag gitlab:latest gitlab:rollback

#docker pull jenkins
docker build -t gitlab:latest ./lsm-INF-001-gitlab

docker stop gitlab-prd
docker rm gitlab-prd

docker run --name=gitlab-prd \
-d -p 60080:80 -p 60443:443 -p 60022:22 \
-v /var/apps/GitLab/config:/etc/gitlab \
-v /var/apps/GitLab/logs:/var/log/gitlab \
-v /var/apps/GitLab/data:/var/opt/gitlab \
--restart=always \
--log-driver=awslogs --log-opt awslogs-region=us-west-2 --log-opt awslogs-group=lsm-INF-logs --log-opt awslogs-stream=lsm-INF-001-gitlab \
gitlab:latest


# Modelo
#sudo docker run --detach \
#    --hostname gitlab.example.com \
#    --publish 443:443 --publish 80:80 --publish 22:22 \
#    --name gitlab \
#    --restart always \
#    --volume /srv/gitlab/config:/etc/gitlab \
#    --volume /srv/gitlab/logs:/var/log/gitlab \
#    --volume /srv/gitlab/data:/var/opt/gitlab \
#    gitlab/gitlab-ce:latest
