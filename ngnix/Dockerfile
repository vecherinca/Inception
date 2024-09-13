FROM debian:latest

RUN apt update && apt upgrade && apt install -y ngnix

CMD ["ngnix", "-g", "daemon off;"]