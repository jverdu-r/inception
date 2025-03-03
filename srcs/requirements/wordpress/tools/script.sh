mkdir -p /var/www/.wp-cli/cache
chown www-data /var/www/.wp-cli/cache

su -s /bin/bash -c "bash /tools/wp_setup.sh" www-data

php-fpm7.4 -F
