#!/bin/bash

if ! sudo -u www-data wp-cli.phar --path=/usr/share/wordpress core is-installed 2> /dev/null; then echo "Downloading WordPress..."
  sudo -u www-data wp-cli.phar --path=/usr/share/wordpress core download
  echo "Creating wp-config.php..."
  sudo -u www-data wp-cli.phar --path=/usr/share/wordpress --skip-check config create --dbname="$DB_NAME" --dbuser="$DB_USER" --dbpass="$DB_PWD" --dbhost=mariadb --dbcharset=utf8mb4 --dbcollate=utf8mb4_general_ci
  echo "Installing WordPress..."
  sudo -u www-data wp-cli.phar --path=/usr/share/wordpress core install --url=http://jverdu-r.42.fr --title=enter_the_gungeon --admin_user="$WP_ADMIN_USR" --admin_password="$WP_ADMIN_PWD" --admin_email="$WP_ADMIN_EMAIL"
  echo "Creating user..."
  sudo -u www-data wp-cli.phar --path=/usr/share/wordpress user create --role=author "$WP_USR" "$WP_EMAIL" --user_pass="$WP_PWD"
fi
