FROM ubuntu:24.04
RUN apt-get update
RUN apt-get install nginx -y
COPY index.nginx-debian.html /var/www/html
ENTRYPOINT ["nginx", "-g" , "daemon off;"] 