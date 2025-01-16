FROM	debian:bullseye

# installing mariadb + utils
RUN		apt-get update -y && \
		apt-get upgrade -y && \
		apt-get install -y mariadb-server \
		mariadb-client \
		# vim \
		&& apt-get clean

# creating necessary directories and giving perms
RUN		mkdir -p /var/run/mysqld/ && \
		mkdir -p /var/lib/mysql/ && \
		chown mysql:mysql /var/run/mysqld/ && \
		chown mysql:mysql /var/lib/mysql/ && \
		chmod -R 755 /var/run/mysqld/ && \
		chmod -R 755 /var/lib/mysql/

# copying mariadb start up script + giving perms
RUN 	mkdir -p /etc/mariadb/startup_script/
COPY	./tools/mariadb-script.sh /etc/mariadb/startup_script/mariadb-script.sh
RUN		chmod -R 755 /etc/mariadb/startup_script/mariadb-script.sh

# copying mariadb config file
COPY	./conf/mysql.conf /etc/mysql/mariadb.conf.d/50-server.cnf

EXPOSE	3306

# executing script
ENTRYPOINT ["bash", "/etc/mariadb/startup_script/mariadb-script.sh"]
