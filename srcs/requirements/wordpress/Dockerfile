FROM wordpress:php8.2-fpm

WORKDIR /var/www/html

COPY conf/wp-config.php /var/www/html/wp-config.php
COPY conf/ /usr/local/etc/php/conf.d/

CMD ["/usr/sbin/php-fpm8.2", "-F"]
