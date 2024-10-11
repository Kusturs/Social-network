DOCKER_COMPOSE := $(shell command -v docker-compose 2> /dev/null)

ifndef DOCKER_COMPOSE
	DOCKER_COMPOSE := docker compose
endif

.PHONY: build up down logs db-setup init

build:
	if [ -f config/master.key ]; then \
		RAILS_MASTER_KEY=$$(cat config/master.key) $(DOCKER_COMPOSE) build --build-arg RAILS_MASTER_KEY=$${RAILS_MASTER_KEY}; \
	else \
		echo "config/master.key not found. Please run 'rails credentials:edit' to create it."; \
		exit 1; \
	fi

up:
	$(DOCKER_COMPOSE) up

down:
	$(DOCKER_COMPOSE) down

logs:
	$(DOCKER_COMPOSE) logs -f

db-setup:
	$(DOCKER_COMPOSE) run --rm web bundle exec rails db:drop db:create db:migrate db:seed

init:
	make build
	make db-setup 
	make up 
