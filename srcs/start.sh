#!/bin/bash

if [[ $autoindex == "off" ]]; then
	rm -f /etc/nginx/sites-available/default_on
	mv -f /etc/nginx/sites-available/default_off /etc/nginx/sites-available/default
else
	rm -f /etc/nginx/sites-available/default_off
	mv -f /etc/nginx/sites-available/default_on /etc/nginx/sites-available/default
	rm -f var/www/html/index.nginx-debian.html
fi
service php7.3-fpm start
service nginx start
service mysql start
bash
