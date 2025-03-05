COMPOSE = docker compose
DOCKER = docker
SRC_DIR = ./srcs
ENV_FILE = $(SRC_DIR)/.env
PROJECT_NAME := inception
DATA_DIR = $(SRC_DIR)/data

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
	#sudo rm -rf certs/nginx.crt certs/nginx.key
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
	docker exec -it srcs-nginx-1 bash

.PHONY: exec-wordpress
exec-wordpress:
	docker exec -it srcs-wordpress-1 bash

.PHONY: exec-mariadb
exec-mariadb:
	docker exec -it srcs-mariadb-1 bash

.PHONY: wp-shell
wp-shell:
	docker exec -it $(PROJECT_NAME)-wordpress-1 bash

.PHONY: db-shell
db-shell:
	docker exec -it $(PROJECT_NAME)-mariadb-1 bash mysql -u ${MYSQL_USER} -p${MYSQL_PASSWORD}
	@echo "Connected to the database."

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
	@echo "  make wp-shell         - Access the WordPress container."
	@echo "  make db-shell         - Access the MariaDB shell."
	@echo "  make fix-permissions  - Give permissions to modify containers files"

.PHONY: create-data-dirs
create-data-dirs:
	mkdir -p $(DATA_DIR)/maria
	mkdir -p $(DATA_DIR)/wp
