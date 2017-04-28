#Dockerfile file

FROM ubuntu:latest

RUN apt-get update && apt-get -y install vim ssh htop git s3cmd nodejs mysql-client ftp mailutils ssmtp cron mutt supervisor

ADD ideaspkg-get-v4.sh /root/bin/ideaspkg_root/ideaspkg-get-v4.sh
ADD ideaspkg-dbwork-v4.sh root/bin/ideaspkg_root/ideaspkg-dbwork-v4.sh
ADD ssmtp.conf /etc/ssmtp
ADD ideaspkg-cron.sched /root/bin/ideaspkg_root/ideaspkg-cron.sched
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN chmod 744 /root/bin/ideaspkg_root/ideaspkg-get-v4.sh \
&& chmod 744 /root/bin/ideaspkg_root/ideaspkg-dbwork-v4.sh \
&& chmod 744 /root/bin/ideaspkg_root/ideaspkg-cron.sched \
&& crontab /root/bin/ideaspkg_root/ideaspkg-cron.sched \
&& mkdir -p /var/log/supervisor \
&& chfn -f "Push Travel-IdeasPkg<no-reply>"

USER root
#CMD ["sh", "-c", "tail -f /dev/null"]
CMD ["/usr/bin/supervisord"]
