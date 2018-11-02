FROM nginx

RUN mkdir /etc/nginx/sites-enabled

ADD mime.types /etc/nginx/mime.types
ADD nginx.conf /etc/nginx/nginx.conf
#ADD ssl /etc/nginx/ssl
ADD sites-enabled/* /etc/nginx/sites-enabled/
