COMPOSE = docker compose
DOCKER = docker
SRC_DIR = ./srcs
ENV_FILE = $(SRC_DIR)/.env
PROJECT_NAME := inception
DATA_DIR = /home/jverdu-r/data

.PHONY: all
all: up

.PHONY: up
up: check-env create-data-dirs
	$(COMPOSE) -f $(SRC_DIR)/docker-compose.yml up --build -d

.PHONY: down
down:
	$(COMPOSE) -f $(SRC_DIR)/docker-compose.yml down

.PHONY: stop
stop:
	$(COMPOSE) -f $(SRC_DIR)/docker-compose.yml stop

.PHONY: start
start:
	$(COMPOSE) -f $(SRC_DIR)/docker-compose.yml start

.PHONY: restart
restart: down up

.PHONY: clean
clean:
	$(COMPOSE) -f $(SRC_DIR)/docker-compose.yml down
	$(COMPOSE) -f $(SRC_DIR)/docker-compose.yml rm -f
	docker image prune -a -f
	docker volume prune -f
	sudo rm -rf $(DATA_DIR)/maria/* # Remove maria data contents
	sudo rm -rf $(DATA_DIR)/wp/* # Remove wp data contents
	rmdir $(DATA_DIR)/maria 2>/dev/null || true # Remove maria directory if empty
	rmdir $(DATA_DIR)/wp 2>/dev/null || true # Remove wp directory if empty

.PHONY: check-env
check-env:
	@if [ ! -f $(ENV_FILE) ]; then echo "Error: .env file missing!" && exit 1; fi
	@echo "Environment file found."

.PHONY: logs
logs:
	$(COMPOSE) -f $(SRC_DIR)/docker-compose.yml logs --tail=50

.PHONY: ps
ps:
	$(COMPOSE) -f $(SRC_DIR)/docker-compose.yml ps

.PHONY: exec-nginx
exec-nginx:
	docker exec -it nginx bash

.PHONY: exec-wordpress
exec-wordpress:
	docker exec -it wordpress bash

.PHONY: exec-mariadb
exec-mariadb:
	docker exec -it mariadb bash

.PHONY: help
help:
	@echo "Available commands:"
	@echo "  make up               - Start and build the containers."
	@echo "  make down             - Stop the containers."
	@echo "  make restart          - Restart the containers."
	@echo "  make clean            - Remove all volumes and images."
	@echo "  make logs             - Show recent logs."
	@echo "  make ps               - Show running containers."
	@echo "  make exec-nginx       - Access the Nginx container."
	@echo "  make exec-wordpress   - Access the WordPress container."
	@echo "  make exec-mariadb     - Access the MariaDB container."


.PHONY: create-data-dirs
create-data-dirs:
	mkdir -p $(DATA_DIR)/maria
	mkdir -p $(DATA_DIR)/wp
