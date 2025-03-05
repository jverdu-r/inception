chown mysql /var/lib/mysql

cat << EOF > /tmp/init_db.sql
CREATE DATABASE IF NOT EXISTS $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE USER IF NOT EXISTS '$DB_USER' IDENTIFIED BY '$DB1_PWD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER';
EOF

mariadbd-safe --init-file=/tmp/init_db.sql
