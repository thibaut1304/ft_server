FROM debian:buster

MAINTAINER thhusser <thhusser@student.42.fr>

RUN apt-get update

RUN apt-get install -y 	nginx \
						mariadb-server \
						php7.3-fpm php-mysql \
						wget

RUN		wget https://wordpress.org/latest.tar.gz && \
		tar -xzvf latest.tar.gz && \
		mv wordpress /var/www/html/wordpress && \
		rm -f latest.tar.gz && \
		chown -R www-data:www-data /var/www/html/wordpress && \
		chmod -R 775 /var/www/html/wordpress/ && \
		rm /var/www/html/wordpress/wp-config-sample.php

RUN		wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-english.tar.gz && \
		tar -xzvf phpMyAdmin-5.0.4-english.tar.gz && \
		mv phpMyAdmin-5.0.4-english /var/www/html/phpmyadmin && \
		rm phpMyAdmin-5.0.4-english.tar.gz

RUN		openssl req -newkey rsa:2048 -nodes -keyout /etc/ssl/private/ssl_key.key \
		-x509 -days 365 -out /etc/ssl/certs/ssl_certificate.crt \
		-subj "/C=FR/ST=92/L=Clichy/O=42/CN=thhusser"

COPY	./srcs/default_on /etc/nginx/sites-available/default_on
COPY	./srcs/default_off /etc/nginx/sites-available/default_off
COPY	./srcs/infos.php ./var/www/html
COPY	./srcs/wp-config.php ./var/www/html/wordpress/wp-config.php
COPY	./srcs/db_wordpress db_wordpress.sql
COPY	./srcs/start.sh ./start.sh

RUN		service mysql start && mysql -u root < db_wordpress.sql

CMD		bash ./start.sh
