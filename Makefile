DOCK_COMP_PATH=./

all: build up

build:
	mkdir -p /home/mklimina/data/mariadb
	mkdir -p /home/mklimina/data/wordpress
	docker-compose -f docker-compose.yml build

up:
	docker-compose -f docker-compose.yml up

down:
	docker-compose -f docker-compose.yml down --rmi all

clean: down
	sudo rm -rf /home/mklimina/data/mariadb/*
	sudo rm -rf /home/mklimina/data/wordpress/*

img_clean:
	docker image rm nginx:latest mariadb:latest wordpress:latest

fclean: clean

logs:
	docker compose -f docker-compose.yml logs

re_up: down all

re: fclean all

.PHONY: all re build up down