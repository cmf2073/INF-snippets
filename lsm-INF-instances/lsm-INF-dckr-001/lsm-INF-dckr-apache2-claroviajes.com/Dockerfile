FROM httpd:2.4

MAINTAINER CmF1.1 <carlos.farina@pushtravel.com>
LABEL version="Apache-CmF-0.1"

RUN apt-get update && apt-get install 

##Copy config files
#COPY ./public-html/ /usr/local/apache2/htdocs/

ENV APACHE_LOG_DIR /var/log/http

#EXPOSE 80
#EXPOSE 443

CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]

