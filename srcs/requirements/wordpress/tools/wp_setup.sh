#!/bin/bash

# Function to read secret from file
read_secret() {
local secret_file="$1"
if [ -f "$secret_file" ]; then
cat "$secret_file"
else
echo "Error: Secret file '$secret_file' not found." >&2
exit 1
fi
}

DB1_NAME=$(read_secret "/run/secrets/DB1_NAME")
DB1_USER=$(read_secret "/run/secrets/DB1_USER")
DB1_PWD=$(read_secret "/run/secrets/DB1_PWD")
WP_MASTER_USER=$(read_secret "/run/secrets/WP_MASTER_USER")
WP_MASTER_PWD=$(read_secret "/run/secrets/WP_MASTER_PWD")
WP_MASTER_EMAIL=$(read_secret "/run/secrets/WP_MASTER_EMAIL")
WP_USER=$(read_secret "/run/secrets/WP_USER")
WP_PWD=$(read_secret "/run/secrets/WP_PWD")
WP_EMAIL=$(read_secret "/run/secrets/WP_EMAIL")

if ! sudo -u www-data wp-cli.phar --path=/usr/share/wordpress core is-installed 2> /dev/null; then
echo "Downloading WordPress..."
sudo -u www-data wp-cli.phar --path=/usr/share/wordpress core download
echo "Creating wp-config.php..."
sudo -u www-data wp-cli.phar --path=/usr/share/wordpress --skip-check config create --dbname="$DB1_NAME" --dbuser="$DB1_USER" --dbpass="$DB1_PWD" --dbhost=mariadb --dbcharset=utf8mb4 --dbcollate=utf8mb4_general_ci
echo "Installing WordPress..."
sudo -u www-data wp-cli.phar --path=/usr/share/wordpress core install --url=http://jverdu-r.42.fr --title=enter_the_gungeon --admin_user="$WP_MASTER_USER" --admin_password="$WP_MASTER_PWD" --admin_email="$WP_MASTER_EMAIL"
echo "Creating user..."
sudo -u www-data wp-cli.phar --path=/usr/share/wordpress user create --role=author "$WP_USER" "$WP_EMAIL" --user_pass="$WP_PWD"
fi
