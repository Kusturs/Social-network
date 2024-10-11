DOCKER_COMPOSE := $(shell command -v docker-compose 2> /dev/null)

ifndef DOCKER_COMPOSE
	DOCKER_COMPOSE := docker compose
endif

.PHONY: build up down logs shell test db-setup

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

console:
	$(DOCKER_COMPOSE) exec web bundle exec rails c

db-test-setup:
	$(DOCKER_COMPOSE) up -d db_test 

run-tests:
	$(DOCKER_COMPOSE) run --rm web bash -c "bundle exec rails db:test:prepare && bundle exec rspec"

test:
	make db-test-setup
	make run-tests

db-setup:
	$(DOCKER_COMPOSE) run --rm web bundle exec rails db:drop db:create db:migrate db:seed

init:
	make db-setup 
	make up 

check-compose:
	@echo "Using: $(DOCKER_COMPOSE)"
