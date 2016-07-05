#Dcokerfile file

FROM quantumobject/docker-nagios

RUN apt-get update && apt-get -y install vim ssh mailutils ssmtp \
&& mkdir -p /usr/local/nagios/etc/hosts_groups \
&& mkdir -p /usr/local/nagios/etc/servers \
&& mkdir -p /usr/local/nagios/.ssh \
&& mkdir -p /usr/local/nagios/etc/BackUp-Config 
 
ADD check_ncpa.py /usr/local/nagios/libexec
ADD check_ncpa.py_original /usr/local/nagios/libexec
ADD check_by_ssh /usr/local/nagios/libexec
ADD hosts_groups /usr/local/nagios/etc/hosts_groups
ADD htpasswd.users /usr/local/nagios/etc/htpasswd.users
ADD nagios.cfg /usr/local/nagios/etc/nagios.cfg
ADD objects/commands.cfg /usr/local/nagios/etc/objects
ADD objects/contacts.cfg /usr/local/nagios/etc/objects
ADD objects/localhost.cfg /usr/local/nagios/etc/objects
ADD servers /usr/local/nagios/etc/servers
ADD objects/adianchi /usr/local/nagios/etc/objects
ADD objects/adianchi /usr/local/nagios/.ssh/id_rsa
ADD objects/known_hosts /usr/local/nagios/.ssh
ADD ssmtp.conf /etc/ssmtp
ADD startup.sh /usr/local/nagios
ADD rc.local /etc

RUN chmod 600 /usr/local/nagios/etc/objects/adianchi \
&& chmod 600 /usr/local/nagios/.ssh/id_rsa \
&& chmod 755 /usr/local/nagios/libexec/check_ncpa.py \
&& chown nagios:nagios /usr/local/nagios/etc/objects/adianchi \
&& chown nagios:nagios /usr/local/nagios/libexec/check_ncpa.py \
&& chown nagios:nagios /usr/local/nagios/libexec/check_by_ssh \
&& chown nagios:nagios /usr/local/nagios/.ssh/* \
&& chmod 755 /usr/local/nagios/startup.sh \
&& chmod 755 /etc/rc.local

