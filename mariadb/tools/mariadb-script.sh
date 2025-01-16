#!/bin/bash

# starting MariaDB in the background to perform setup
mysqld_safe &
pid="$!"

# using the mysqladmin utility to wait for server to finish starting
while ! mysqladmin ping --silent; do
    echo "Waiting for MariaDB to start..."
    sleep 2
done

# database and user setup
mysql -uroot <<-EOSQL && echo -e "mariadb queries [\033[32mOK\033[0m]"
    CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;
    CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON ${SQL_DATABASE}.* TO ${SQL_USER}@'%' IDENTIFIED BY '${SQL_PASSWORD}';
    FLUSH PRIVILEGES;
    SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${SQL_ROOT_PASSWORD}');
    FLUSH PRIVILEGES;
EOSQL

# clean stop MariaDB (avoid using tail -f, sleep)
mysqladmin -uroot -p${SQL_ROOT_PASSWORD} shutdown

# waiting for MariaDB to finish shutting down
wait "$pid"

# starting MariaDB in the foreground
exec mysqld_safe
