#Dcokerfile file

FROM quantumobject/docker-nagios

RUN mkdir -p /usr/local/nagios/etc/hosts_groups \
&& mkdir -p /usr/local/nagios/etc/servers \
&& mkdir -p /usr/local/nagios/etc/BackUp-Config
 
ADD check_ncpa.py /usr/local/nagios/libexec
ADD check_by_ssh /usr/local/nagios/libexec
ADD hosts_groups /usr/local/nagios/etc/hosts_groups
ADD htpasswd.users /usr/local/nagios/etc/htpasswd.users
ADD nagios.cfg /usr/local/nagios/etc/nagios.cfg
ADD objects/commands.cfg /usr/local/nagios/etc/objects
ADD objects/contacts.cfg /usr/local/nagios/etc/objects
ADD servers /usr/local/nagios/etc/servers
ADD objects/adianchi /usr/local/nagios/etc/objects

RUN chmod 600 /usr/local/nagios/etc/objects/adianchi \
&& chown nagios:nagios /usr/local/nagios/etc/objects/adianchi \
&& chown nagios:nagios /usr/local/nagios/libexec/check_ncpa.py \
&& chown nagios:nagios /usr/local/nagios/libexec/check_by_ssh
