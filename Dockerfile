FROM	debian:buster

MAINTAINER thhusser <thhusser@student.42.fr>

ENV DEBIAN_FRONTEND noninteractive

#		install wget, nginx, mariadb, php, mysql
RUN		apt-get -y update && apt-get -y upgrade && \
		apt-get install -y \
		wget \
		nginx \
		mariadb-server mariadb-client\
		php-fpm php-mysql

#		install wordpress and giving rights
RUN		wget https://wordpress.org/latest.tar.gz && \
		tar -xzvf latest.tar.gz && \
		mv wordpress /var/www/html/wordpress && \
		rm latest.tar.gz && \
		chown -R www-data:www-data /var/www/html/wordpress/ &&\
		chmod -R 755 /var/www/html/wordpress/ && \
		rm var/www/html/index.nginx-debian.html && rm /var/www/html/wordpress/wp-config-sample.php

#		install phpMyAdmin
RUN		wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-english.tar.gz && \
		tar -xzvf phpMyAdmin-5.0.1-english.tar.gz && \
		mv phpMyAdmin-5.0.1-english /var/www/html/phpmyadmin && \
		rm phpMyAdmin-5.0.1-english.tar.gz

#		create SSL key and certificate
RUN		openssl req -newkey rsa:2048 -nodes -keyout /etc/ssl/private/ssl_key.key \
		-x509 -days 365 -out /etc/ssl/certs/ssl_certificate.crt \
		-subj "/C=FR/ST=Paris/L=Paris/O=42/OU=42/CN=thhusser"

#		Copy settings files into the container
COPY	./srcs/default ./etc/nginx/sites-available/default
COPY	./srcs/infos.php ./var/www/html
COPY	./srcs/wp-config.php ./var/www/html/wordpress/wp-config.php
COPY	./srcs/db_wordpress db_wordpress
COPY	./srcs/service.sh service.sh
COPY	./srcs/start.sh start.sh

#		start mysql and initialize the wordpress database
RUN		service mysql start && mysql -u root < db_wordpress

#		start the server
CMD		["./start.sh", "bash"]