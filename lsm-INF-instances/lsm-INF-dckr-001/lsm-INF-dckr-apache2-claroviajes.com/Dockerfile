FROM httpd:2.4

MAINTAINER CmF1.1 <carlos.farina@pushtravel.com>
LABEL version="Apache-CmF-0.1"

RUN apt-get update && apt-get -y install vim \
&& mkdir /usr/local/apache2/sites-enabled

##Copy config files
#COPY ./public-html/ /usr/local/apache2/htdocs/

ENV APACHE_LOG_DIR /usr/local/apache2/logs
ADD httpd.conf /usr/local/apache2/conf/httpd.conf
ADD sites-enabled/*.conf /usr/local/apache2/sites-enabled/

EXPOSE 80
EXPOSE 443

#CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]

