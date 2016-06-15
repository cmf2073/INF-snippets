FROM httpd:2.4

MAINTAINER CmF1.1 <carlos.farina@pushtravel.com>
LABEL version="Apache-CmF-0.2"

RUN apt-get update && apt-get -y install vim \
&& mkdir /usr/local/apache2/sites-enabled \
&& mkdir /usr/local/apache2/sites-available \
&& mkdir /etc/ssl

##Copy config files
#COPY ./public-html/ /usr/local/apache2/htdocs/

ENV APACHE_LOG_DIR /usr/local/apache2/logs
ADD httpd.conf /usr/local/apache2/conf/httpd.conf
ADD sites-enabled/* /usr/local/apache2/sites-enabled/
ADD sites-available/* /usr/local/apache2/sites-available/
ADD ssl-certs/* /etc/ssl/
ADD modules/mod_proxy_html.so /usr/local/apache2/modules/
ADD modules/mod_xml2enc.so /usr/local/apache2/modules/
ADD modules/libxml2.so.2 /usr/lib/x86_64-linux-gnu/ 

EXPOSE 80
EXPOSE 443

#CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]

