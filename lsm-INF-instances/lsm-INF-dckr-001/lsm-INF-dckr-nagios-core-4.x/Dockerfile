#Dcokerfile file

FROM quantumobject/docker-nagios


ADD hosts_groups /usr/local/nagios/etc
ADD htpasswd.users /usr/local/nagios/etc/htpasswd.users
ADD nagios.cfg /usr/local/nagios/etc/nagios.cfg
ADD objects /usr/local/nagios/etc
ADD servers /usr/local/nagios/etc
