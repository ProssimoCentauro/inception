# Variables
DATA_PATH = /home/$(USER)/data

all: build up

build:
	docker compose -f srcs/docker-compose.yml build

up:
	mkdir -p $(DATA_PATH)/wordpress $(DATA_PATH)/mariadb
	docker compose -f srcs/docker-compose.yml up -d

down:
	docker compose -f srcs/docker-compose.yml down

clean: down
	docker system prune -af

fclean: clean
	docker volume rm mariadb_data wordpress_files || true
	sudo rm -rf $(DATA_PATH)

re: fclean all

.PHONY: all build up down clean fclean re
