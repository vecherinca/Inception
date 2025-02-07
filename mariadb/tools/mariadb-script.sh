#!/bin/bash

# starting MariaDB in the background to perform setup
echo -e "\e[1;36m================ 🌟 STARTING MARIA DB 🌟 =================\e[0m"
mysqld_safe &
pid="$!"

# using the mysqladmin utility to wait for server to finish starting
echo -e "\e[1;33m============== ⏳ WAITING FOR MARIA DB ⏳ ==============\e[0m"
while ! mysqladmin ping --silent; do
    echo -e "\e[1;35mWaiting for MariaDB to start... ⏳\e[0m"
    sleep 2
done

# database and user setup
echo -e "\e[1;32m============== 🔨 SETTING UP DATABASE 🔨 ==============\e[0m"
mysql -uroot <<-EOSQL && echo -e "\e[1;32mmariadb queries [\033[32mOK\033[0m] 🎉"
    CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;
    CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON ${SQL_DATABASE}.* TO ${SQL_USER}@'%' IDENTIFIED BY '${SQL_PASSWORD}';
    FLUSH PRIVILEGES;
    SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${SQL_ROOT_PASSWORD}');
    FLUSH PRIVILEGES;
EOSQL

# clean stop MariaDB (avoid using tail -f, sleep)
echo -e "\e[1;31m=========== 🛑 STOPPING MARIA DB 🛑 ===========\e[0m"
mysqladmin -uroot -p${SQL_ROOT_PASSWORD} shutdown

# waiting for MariaDB to finish shutting down
echo -e "\e[1;33m============== ⏳ WAITING FOR SHUTDOWN ⏳ ==============\e[0m"
wait "$pid"

# starting MariaDB in the foreground
echo -e "\e[1;36m================ ⚡ STARTING MARIA DB (FG) ⚡ =================\e[0m"
exec mysqld
