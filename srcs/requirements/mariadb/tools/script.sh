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

DB1_MASTER_PWD=$(read_secret "/run/secrets/DB1_MASTER_PWD")
DB1_USER=$(read_secret "/run/secrets/DB1_USER")
DB1_PWD=$(read_secret "/run/secrets/DB1_PWD")
DB1_NAME="$MARIADB_DATABASE"

echo "DEBUG - DB1_MASTER_PWD: $DB1_MASTER_PWD"
echo "DEBUG - DB1_USER: $DB1_USER"
echo "DEBUG - DB1_PWD: $DB1_PWD"
echo "DEBUG - DB1_NAME: $DB1_NAME"
echo "DEBUG - MARIADB_DATABASE: $MARIADB_DATABASE"

# Ensure data directory exists and set proper ownership
mkdir -p /var/lib/mysql
chown -R mysql:mysql /var/lib/mysql

# Explicitly create the socket directory and set permissions
mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld
chmod 777 /run/mysqld # Give broad permissions for testing

# Start MariaDB in the background
/usr/sbin/mariadbd --user=mysql &

# Wait for MariaDB to be ready
while [ ! -S /var/run/mysqld/mysqld.sock ]; do
  echo "Waiting for MariaDB socket..."
  sleep 2
done

# Initialize the database
mysql -u root -p"$DB1_MASTER_PWD" -e "CREATE DATABASE IF NOT EXISTS $DB1_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"
mysql -u root -p"$DB1_MASTER_PWD" -e "CREATE USER IF NOT EXISTS '$DB1_USER' IDENTIFIED BY '$DB1_PWD';"
mysql -u root -p"$DB1_MASTER_PWD" -e "GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER, INDEX, LOCK TABLES, EXECUTE ON $DB1_NAME.* TO '$DB1_USER';"
mysql -u root -p"$DB1_MASTER_PWD" -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '$DB1_MASTER_PWD' WITH GRANT OPTION;"
mysql -u root -p"$DB1_MASTER_PWD" -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'127.0.0.1' IDENTIFIED BY '$DB1_MASTER_PWD' WITH GRANT OPTION;"
mysql -u root -p"$DB1_MASTER_PWD" -e "FLUSH PRIVILEGES;"

echo "MariaDB initialization complete."

# Keep the container running
tail -f /dev/null
