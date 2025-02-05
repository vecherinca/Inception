FROM	debian:bullseye

# installing nginx + utils
RUN 	apt-get update -y && \
		apt-get upgrade -y && \
		apt-get install -y nginx \
		openssl \
		# vim \
        curl && \
        apt-get clean
# creating ssl contract and its location + autosigning it
RUN		mkdir -p /etc/nginx/ssl/
RUN		openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout \
		/etc/nginx/ssl/inception.key -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=mklimina.42.fr/UID=mklimina@student.42.fr"

# creating run/nginx/file
RUN		mkdir -p /var/run/nginx/

# giving perms to www/html/
RUN 	chmod 755 /var/www/html/ && \
		chown -R www-data:www-data /var/www/html/

# copying nginx config file
COPY 	./nginx.conf /etc/nginx/nginx.conf

EXPOSE	443

CMD		["nginx", "-g", "daemon off;"]
