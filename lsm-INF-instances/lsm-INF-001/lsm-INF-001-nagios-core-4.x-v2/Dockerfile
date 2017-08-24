#Dcokerfile file

FROM jasonrivers/nagios

RUN apt-get update && apt-get -y install vim ssh mailutils ssmtp python \
&& mkdir -p /opt/nagios/etc/hosts_groups \
&& mkdir -p /opt/nagios/etc/servers \
&& mkdir -p /opt/nagios/.ssh \
&& mkdir -p /opt/nagios/etc/BackUp-Config

ADD check_curl_smt_handler.sh /opt/nagios/libexec
ADD check_ncpa.py /opt/nagios/libexec
ADD check_ncpa.py_original /opt/nagios/libexec
ADD check_ncpa-1.1.1.py /opt/nagios/libexec
ADD check_by_ssh /opt/nagios/libexec
ADD hosts_groups /opt/nagios/etc/hosts_groups
ADD htpasswd.users /opt/nagios/etc/htpasswd.users
## ADD nagios.cfg /opt/nagios/etc/nagios.cfg
ADD nagios_custom.cfg /opt/nagios/etc/nagios.cfg
ADD objects/commands.cfg /opt/nagios/etc/objects
ADD objects/contacts.cfg /opt/nagios/etc/objects
ADD objects/localhost.cfg /opt/nagios/etc/objects
ADD servers /opt/nagios/etc/servers
ADD objects/adianchi /opt/nagios/etc/objects
ADD objects/adianchi /opt/nagios/.ssh/id_rsa
ADD objects/known_hosts /opt/nagios/.ssh
ADD ssmtp.conf /etc/ssmtp
ADD startup.sh /opt/nagios
ADD rc.local /etc

RUN chmod 600 /opt/nagios/etc/objects/adianchi \
&& chmod 600 /opt/nagios/.ssh/id_rsa \
&& chmod 777 /opt/nagios/libexec/check_ncpa.py \
&& chmod 777 /opt/nagios/libexec/check_ncpa-1.1.1.py \
&& chmod 777 /opt/nagios/libexec/check_curl_smt_handler.sh \
&& chown nagios:nagios /opt/nagios/etc/objects/adianchi \
&& chown nagios:nagios /opt/nagios/libexec/check_ncpa.py \
&& chown nagios:nagios /opt/nagios/libexec/check_curl_smt_handler.sh \
&& chown nagios:nagios /opt/nagios/libexec/check_by_ssh \
&& chown nagios:nagios /opt/nagios/.ssh/* \
&& chown nagios:nagios /opt/nagios/libexec/* \
&& chmod 755 /opt/nagios/startup.sh \
&& chmod 755 /etc/rc.local
