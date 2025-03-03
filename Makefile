COMPOSE = docker compose
DOCKER = docker
SRC_DIR = ./srcs
ENV_FILE = $(SRC_DIR)/.env
PROJECT_NAME := inception

.PHONY: all
all: up

.PHONY: up
up: check-env
	$(COMPOSE) -f $(SRC_DIR)/docker-compose.yml up --build -d
	
.PHONY: down
down:
	$(COMPOSE) -f $(SRC_DIR)/docker-compose.yml down

.PHONY:
stop:
	$(COMPOSE) -f $(SRC_DIR)/docker-compose.yml stop

.PHONY:
start:
	$(COMPOSE) -f $(SRC_DIR)/docker-compose.yml start

.PHONY: restart
restart: down up

.PHONY: clean
clean:
	$(COMPOSE) -f $(SRC_DIR)/docker-compose.yml down
	$(COMPOSE) -f $(SRC_DIR)/docker-compose.yml rm -f
	docker image prune -a -f
	docker volume prune -f  # Still important for other volume types
	sudo rm -rf certs/nginx.crt certs/nginx.key # Remove certificates
	sudo rm -rf wordpress_data/* # Clear wordpress data
	sudo rm -rf mariadb_data/*  # Clear mariadb data

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

.PHONY: exec-nginx  # Added exec-nginx
exec-nginx:
	docker exec -it srcs-nginx-1 bash

.PHONY: exec-wordpress  # Added exec-wordpress
exec-wordpress:
	docker exec -it srcs-wordpress-1 bash

.PHONY: exec-mariadb  # Added exec-mariadb
exec-mariadb:
	docker exec -it srcs-mariadb-1 bash

.PHONY: wp-shell  # (Alternative way to access WordPress)
wp-shell:
	docker exec -it $(PROJECT_NAME)-wordpress-1 bash

.PHONY: db-shell  # (Alternative way to access MariaDB)
db-shell:
	docker exec -it $(PROJECT_NAME)-mariadb-1 bash mysql -u ${MYSQL_USER} -p${MYSQL_PASSWORD}
	@echo "Connected to the database."

.PHONY: fix-permissions
fix-permissions:
	sudo chown -R $(USER):$(USER) mariadb_data wordpress_data  # Corrected path
	sudo chmod -R 755 mariadb_data wordpress_data  # Corrected path
	@echo "Fixed permissions for $(DATA_DIR)"

.PHONY: help
help:
	@echo "Available commands:"
	@echo "  make up               - Start and build the containers."
	@echo "  make down             - Stop the containers."
	@echo "  make restart          - Restart the containers."
	@echo "  make clean            - Remove all volumes and images."
	@echo "  make logs             - Show recent logs."
	@echo "  make ps               - Show running containers."
	@echo "  make exec-nginx        - Access the Nginx container."
	@echo "  make exec-wordpress   - Access the WordPress container."
	@echo "  make exec-mariadb     - Access the MariaDB container."
	@echo "  make wp-shell         - Access the WordPress container."
	@echo "  make db-shell         - Access the MariaDB shell."
	@echo "  make fix-permissions - Give permissions to modify containers files"
