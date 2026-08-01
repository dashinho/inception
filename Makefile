# ==============================================================================
# Variables
# ==============================================================================

USER			= your_login

COMPOSE_FILE	= srcs/docker-compose.yml

DATA_PATH		= /home/$(USER)/data
WP_DATA			= $(DATA_PATH)/wordpress
DB_DATA			= $(DATA_PATH)/mariadb

# ==============================================================================
# Rules
# ==============================================================================

all: build up

build:
	@echo "Creating volume directories on host..."
	@mkdir -p $(WP_DATA)
	@mkdir -p $(DB_DATA)
	@echo "Building Docker images..."
	@docker-compose -f $(COMPOSE_FILE) build

up:
	@echo "Starting containers..."
	@docker-compose -f $(COMPOSE_FILE) up -d

down:
	@echo "Stopping containers..."
	@docker-compose -f $(COMPOSE_FILE) down

clean:
	@echo "Stopping and removing containers, networks, and volumes..."
	@docker-compose -f $(COMPOSE_FILE) down -v

fclean: clean
	@echo "Removing local volume data..."
	@sudo rm -rf $(DATA_PATH)
	@echo "Pruning all unused Docker images and networks..."
	@docker system prune -a --force

re: fclean all

logs:
	@docker-compose -f $(COMPOSE_FILE) logs -f

status:
	@docker-compose -f $(COMPOSE_FILE) ps

.PHONY: all build up down clean fclean re logs status