# Docker file example #1
# We'll build a container based in ubuntu


MAINTAINER Example CMF

FROM ubuntu
RUN apt-get update
RUN apt-get install -y htop
RUN apt-get install -y whois
RUN mkdir ~/test-folder


