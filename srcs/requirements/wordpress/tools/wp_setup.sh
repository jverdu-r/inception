service php7.4-fpm restart
if ! sudo -u www-data wp-cli.phar --path=/usr/share/wordpress core is-installed 2> /dev/null; then
	sudo -u www-data wp-cli.phar --path=/usr/share/wordpress core download
	sudo -u www-data wp-cli.phar --path=/usr/share/wordpress --skip-check config create --dbname=wp_db --dbuser="$DB_USER" --dbpass="$DB_PWD" --dbhost=mariadb --dbcharset=utf8mb4 --dbcollate=utf8mb4_general_ci
	sudo -u www-data wp-cli.phar --path=/usr/share/wordpress core install --url=https://jverdu-r.42.fr --title=miaumiau --admin_user="$WP_ADMIN_USR" --admin_password="$WP_ADMIN_PWD" --admin_email="$WP_ADMIN_EMAIL"
	sudo -u www-data wp-cli.phar --path=/usr/share/wordpress user create --role=author "$WP_USER" "$WP_EMAIL" --user_pass="$WP_PWD"
fi
