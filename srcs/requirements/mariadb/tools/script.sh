chown mysql /var/lib/mysql

cat << EOF > /tmp/init_db.sql
CREATE DATABASE IF NOT EXISTS $DB1_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- Create the application user with limited privileges
CREATE USER IF NOT EXISTS '$DB1_USER' IDENTIFIED BY '$DB1_PWD';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER, INDEX, LOCK TABLES, EXECUTE ON $DB_NAME.* TO '$DB_USER';

-- Create the admin user with all privileges
CREATE USER IF NOT EXISTS '$DB1_MASTER' IDENTIFIED BY '$DB1_MASTER_PWD';
GRANT ALL PRIVILEGES ON *.* TO '$DB1_MASTER' WITH GRANT OPTION;
FLUSH PRIVILEGES;

EOF


mariadbd-safe --init-file=/tmp/init_db.sql