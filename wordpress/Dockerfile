FROM	debian:bullseye

# installing php + utils & mariadb-client
RUN		apt-get update -y && \
		apt-get upgrade -y && \
		apt-get install -y wget \
		php \
		php-fpm \
		php-mysql \
		mariadb-client && \
		apt-get clean

# env variables for individual testing (without docker compose)
ENV SQL_DATABASE=db_inception
ENV SQL_USER=db_user
ENV SQL_PASSWORD=db_password
ENV SQL_ROOT_PASSWORD=db_root_password
ENV SQL_HOST=mariadb:3306

# downloading wordpress and extracting files
RUN		wget https://fr.wordpress.org/wordpress-6.3.2-fr_FR.tar.gz -P /var/www/html/ && \
		cd /var/www/html/ && tar -xzf wordpress-6.3.2-fr_FR.tar.gz && \
		rm wordpress-6.3.2-fr_FR.tar.gz

# downloading wp automatic conf tool
RUN		wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
		chmod +x wp-cli.phar && \
		mv wp-cli.phar /usr/local/bin/wp

# giving perms
RUN		chown -R root:root /var/www/html/wordpress/ && \
		chown -R www-data:www-data /var/www/* && \
		chmod -R 755 /var/www/*

# copying startup script to setup wordpress and giving perms
RUN		mkdir -p /etc/wordpress/startup_script/
COPY	./tools/wp-script.sh /etc/wordpress/startup_script/wp-script.sh
RUN		chmod +x /etc/wordpress/startup_script/wp-script.sh

# copying conf file for php-fpm
COPY	./conf/www.conf/ /etc/php/7.3/fpm/pool.d/www.conf
COPY	./conf/www.conf/ /etc/php/7.4/fpm/pool.d/www.conf

# adding options to the php.ini file
RUN		echo "clear_env=no" >> /etc/php/7.4/fpm/php.ini && \
		echo "listen=wordpress:9000" >> /etc/php/7.4/fpm/php.ini

EXPOSE	9000

# executing script
CMD		["bash", "/etc/wordpress/startup_script/wp-script.sh"]
