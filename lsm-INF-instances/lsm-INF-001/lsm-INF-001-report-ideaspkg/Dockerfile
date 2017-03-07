#Dockerfile file

FROM ubuntu:latest

RUN apt-get update && apt-get -y install vim ssh htop git s3cmd nodejs mysql-client ftp

ADD ideaspkg-get-v4.sh /root/bin/ideaspkg_root/ideaspkg-get-v4.sh
ADD ideaspkg-dbwork-v2.sh root/bin/ideaspkg_root/ideaspkg-dbwork-v2.sh

CMD ["sh", "-c", "tail -f /dev/null"]
