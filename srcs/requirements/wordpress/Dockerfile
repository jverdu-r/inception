FROM wordpress:php8.2-fpm

WORKDIR /var/www/html

COPY conf/ /usr/local/etc/php/conf.d/

EXPOSE 9000

CMD ["php-fpm"]