# Variables
COMPOSE = docker-compose
DOCKER = docker
SRC_DIR = ./srcs
ENV_FILE = $(SRC_DIR)/.env
DATA_DIR = /home/dungeonmaster/Documentos/inception
DB_DIR = $(DATA_DIR)/db_data
WP_DIR = $(DATA_DIR)/wp_data
NGINX_DIR = $(DATA_DIR)/nginx_conf

# Default target
.PHONY: all
all: up

# Build and start containers
.PHONY: up
up: check-env create-dirs
	$(COMPOSE) -f $(SRC_DIR)/docker-compose.yml up --build -d

# Create required directories if they don't exist
.PHONY: create-dirs
create-dirs:
	@mkdir -p $(DB_DIR) $(WP_DIR) $(NGINX_DIR)
	@echo "Directories $(DB_DIR), $(WP_DIR), and $(NGINX_DIR) created or already exist."

# Stop containers
.PHONY: down
down:
	$(COMPOSE) -f $(SRC_DIR)/docker-compose.yml down

# Restart containers
.PHONY: restart
restart: down up

# Clean up volumes and rebuild everything
.PHONY: clean
clean: down
	rm -rf $(DB_DIR) $(WP_DIR) $(NGINX_DIR)
	$(DOCKER) volume prune -f
	$(DOCKER) system prune -af --volumes
	@echo "All Docker data removed."

# Check if .env file exists
.PHONY: check-env
check-env:
	@if [ ! -f $(ENV_FILE) ]; then echo "Error: .env file missing!" && exit 1; fi
	@echo "Environment file found."

# Display logs
.PHONY: logs
logs:
	$(COMPOSE) -f $(SRC_DIR)/docker-compose.yml logs --tail=50

# Show running containers
.PHONY: ps
ps:
	$(COMPOSE) -f $(SRC_DIR)/docker-compose.yml ps

# Connect to the WordPress container
.PHONY: wp-shell
wp-shell:
	$(DOCKER) exec -it wordpress bash

# Connect to the MariaDB container
.PHONY: db-shell
db-shell:
	$(DOCKER) exec -it mariadb mysql -u ${MYSQL_USER} -p${MYSQL_PASSWORD}
	@echo "Connected to the database."

# Run Makefile help
.PHONY: help
help:
	@echo "Available commands:"
	@echo "  make up        - Start and build the containers."
	@echo "  make down      - Stop the containers."
	@echo "  make restart   - Restart the containers."
	@echo "  make clean     - Remove all volumes and images."
	@echo "  make logs      - Show recent logs."
	@echo "  make ps        - Show running containers."
	@echo "  make wp-shell  - Access the WordPress container."
	@echo "  make db-shell  - Access the MariaDB shell."

