# Variables
DOCKER = docker
DOCKER_COMPOSE = docker-compose
EXEC = $(DOCKER) exec -it php-fpm
PHP = $(EXEC) php
COMPOSER = $(EXEC) composer
NPM = $(EXEC) npm
SYMFONY_CONSOLE = $(PHP) bin/console

# Colors
GREEN = /bin/echo -e "\x1b[32m\#\# $1\x1b[0m"
RED = /bin/echo -e "\x1b[31m\#\# $1\x1b[0m"

## —— 🔥 App —————————————————————————————————————————————————————————————————
init: ## Init the project
	$(MAKE) create-folders
	$(MAKE) build
	$(MAKE) start
	$(COMPOSER) create-project symfony/skeleton:"7.0.*" .
	$(COMPOSER) require symfony/webpack-encore-bundle
	$(MAKE) npm-install
	@$(call GREEN,"The application is available at: http://127.0.0.1:80/.")
	@$(call GREEN,"The Pgadmin is available at: http://127.0.0.1:5000/.")

cache-clear: ## Clear cache
	$(SYMFONY_CONSOLE) cache:clear

## —— ✅ Test —————————————————————————————————————————————————————————————————
.PHONY: tests
tests: ## Run all tests
	$(MAKE) database-init-test
	$(PHP) bin/phpunit --testdox tests/Unit/
	$(PHP) bin/phpunit --testdox tests/Functional/
	$(PHP) bin/phpunit --testdox tests/E2E/

database-init-test: ## Init database for test
	$(SYMFONY_CONSOLE) d:d:d --force --if-exists --env=test
	$(SYMFONY_CONSOLE) d:d:c --env=test
	$(SYMFONY_CONSOLE) d:m:m --no-interaction --env=test
	$(SYMFONY_CONSOLE) d:f:l --no-interaction --env=test

unit-test: ## Run unit tests
	$(MAKE) database-init-test
	$(PHP) bin/phpunit --testdox tests/Unit/

functional-test: ## Run functional tests
	$(MAKE) database-init-test
	$(PHP) bin/phpunit --testdox tests/Functional/

# PANTHER_NO_HEADLESS=1 ./bin/phpunit --filter LikeTest --debug to debug with Chrome
e2e-test: ## Run E2E tests
	$(MAKE) database-init-test
	$(PHP) bin/phpunit --testdox tests/E2E/

## —— 🐳 Docker —————————————————————————————————————————————————————————————————
build: ## Build app with fresh images
	$(DOCKER_COMPOSE) build

start: ## Start app
	$(MAKE) docker-start

docker-start: 
	$(DOCKER_COMPOSE) up -d

stop: ## Stop app
	$(MAKE) docker-stop
	
docker-stop: 
	$(DOCKER_COMPOSE) stop
	@$(call RED,"The containers are now stopped.")

## —— 🎻 Composer ——
composer-install: ## Install dependencies
	$(COMPOSER) install

composer-update: ## Update dependencies
	$(COMPOSER) update

composer-clear-cache: ## clear-cache dependencies
	$(COMPOSER) clear-cache

## —— 🐈 NPM —————————————————————————————————————————————————————————————————
npm-install: ## Install all npm dependencies
	$(NPM) install

npm-update: ## Update all npm dependencies
	$(NPM) update

npm-watch: ## Update all npm dependencies
	$(NPM) run watch

## —— 📊 Database —————————————————————————————————————————————————————————————————
database-init: ## Init database
	$(MAKE) database-drop
	$(MAKE) database-create
	$(MAKE) database-migrate
	$(MAKE) database-fixtures-load

database-drop: ## Create database
	$(SYMFONY_CONSOLE) d:d:d --force --if-exists

database-create: ## Create database
	$(SYMFONY_CONSOLE) d:d:c --if-not-exists

database-remove: ## Drop database
	$(SYMFONY_CONSOLE) d:d:d --force --if-exists

database-migration: ## Make migration
	$(SYMFONY_CONSOLE) make:migration

migration: ## Alias : database-migration
	$(MAKE) database-migration

database-migrate: ## Migrate migrations
	$(SYMFONY_CONSOLE) d:m:m --no-interaction

migrate: ## Alias : database-migrate
	$(MAKE) database-migrate

database-fixtures-load: ## Load fixtures
	$(SYMFONY_CONSOLE) d:f:l --no-interaction

fixtures: ## Alias : database-fixtures-load
	$(MAKE) database-fixtures-load

create-folders: ## Create data folders
	mkdir -p ./app ./data/postgres ./logs/nginx

## —— 🛠️  Others —————————————————————————————————————————————————————————————————
help: ## List of commands
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'