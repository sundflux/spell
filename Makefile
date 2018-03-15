.PHONY: help build-dev setup-prod clean artifact
.DEFAULT_GOAL := help

# Default environment
ENV := development

# Default source @alias where to sync database and files from
SOURCE := dev

# Profile
PROFILE := config_installer

--pre_build-dev:
	$(call colorecho, "\n### BUILD DEVELOPMENT CODEBASE ###")

build-dev: COMPOSER_ARGS =
build-dev: ENV = development
build-dev: --pre_build-dev vendor docker-up ## Build development codebase and start Docker container

--pre_build-production:
	$(call colorecho, "\n### BUILD PRODUCTION CODEBASE ###")

build-production: COMPOSER_ARGS = --no-dev --optimize-autoloader
build-production: ENV = production
build-production: --pre_build-production --setup vendor ## Build production codebase
	@cp conf/production.* public/sites/default

--pre_build-testing:
	$(call colorecho, "\n### BUILD TESTING CODEBASE ###")

build-testing: COMPOSER_ARGS = --no-dev --optimize-autoloader
build-testing: ENV = testing
build-testing: --pre_build-testing --setup vendor ## Build testing codebase

init: ## Initialise the project
	@echo "Add git pre-commit hook"
	@echo "What else?"

clean: ## Delete node_modules and vendor folders && stop and remove Docker containers
	$(call colorecho, "\n- Delete node_modules and vendor folders...\n")
	@rm -rf node_modules vendor

clean-all: clean ## Delete node_modules and vendor folders
	$(call colorecho, "- Stop and remove Docker container...\n")
	@docker-compose down -v

docker-up: ## Start Docker container
	$(call colorecho, "\n- Start Docker container...\n")
	@docker-compose up -d

--node_modules: package.json docker-up
	$(call colorecho, "\n- Install --node modules inside Docker container...\n")
	$(call call_in_root,npm install --engine-strict true)

--pre_reset-local:
	$(call colorecho, "\n### RESET LOCAL ENVIRONMENT ###")

reset-local: --pre_reset-local clean-all --setup vendor docker-up --node_modules ## Reset local environment syncing from source specified
	$(call colorecho, "\n- Sync database from @${SOURCE}...\n")
	$(call call_in_webroot, drush sql-drop -y)
	$(call call_in_webroot, drush -y sql-sync @${SOURCE} @self)
	$(call colorecho, "\n- Sync files from @${SOURCE}...\n")
	@mkdir -p -m 0777 files files_private
	$(call call_in_webroot, drush -y rsync --mode=akzu @${SOURCE}:%files @self:%files)
	$(call colorecho, "\n- Run database updates...\n")
	$(call call_in_webroot, drush -y updb)
	$(call colorecho, "\n- Import configuration...\n")
	$(call call_in_webroot, drush -y cim)
	$(call colorecho, "\n- DONE! Login to your site with:\n")
	$(call call_in_webroot, drush uli)
	@echo "\n"

--pre_fresh:
	$(call colorecho, "\n### MAKE FRESH INSTANCE ###")

fresh: --pre_fresh clean-all --setup vendor docker-up --node_modules ## Create fresh empty installation
	$(call colorecho, "\n- Install site...\n")
	$(call call_in_webroot, drush si ${PROFILE} -y)
#	$(call colorecho, "\n- Generate content:\n")
#	$(call call_in_webroot, ../vendor/bin/drupal drula:generate:content)
	$(call colorecho, "\n- DONE! Login to your site with:\n")
	$(call call_in_webroot, drush uli)
	@echo "\n"

update: ## Run composer update to update dependencies
	$(call colorecho, "\n### Upgrades Composer dependencies and updates the composer.lock file ###\n")
	@composer update --with-dependencies --no-scripts --no-suggest --prefer-dist

--pre_artifact:
	$(call colorecho, "\n### CREATE ARTIFACT ###")

artifact: --pre_artifact vendor ## Make tar.gz package from the current installation
	$(call colorecho, "\n- Create artifact:\n")
	@tar -hczf artifact.tar.gz --files-from=conf/artifact/include --exclude-from=conf/artifact/exclude

vendor: composer.json composer.lock
	$(call colorecho, "\n- Validate composer.json...\n")
	@composer validate
	$(call colorecho, "\n- Install codebase with Composer...\n")
	composer install ${COMPOSER_ARGS} --prefer-dist --no-suggest --ignore-platform-reqs
	$(call colorecho, "\n- Run drupal-scaffold...\n")
	@composer drupal-scaffold
	@echo "\n"

--setup:
	$(call colorecho, "\n- Check that folders exist...\n")
	@mkdir -p -m 0777 files files_private public/sites/default
	@chmod 0755 public/sites/default
	@ln -sfn ../../../files public/sites/default/files
	$(call colorecho, "\n- Copy configuration...\n")
	@cp conf/all.* public/sites/default
	@rm -f public/sites/default/settings.php
	@cp conf/settings.php public/sites/default/settings.php

help: ## Print this help
	$(call colorecho, "\nAvailable make commands:\n")
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo ""

define call_in_webroot
    @docker-compose exec -T --user drupal drupal bash -c "source ~/.bash_envvars && cd \"$$AMAZEEIO_WEBROOT\" && PATH=`pwd`/../vendor/bin:\$$PATH && $(1)"
endef

define call_in_root
    @docker-compose exec -T --user drupal drupal bash -c "source ~/.bash_envvars && cd .. && PATH=`pwd`/../vendor/bin:\$$PATH && $(1)"
endef

define colorecho
    @tput -T xterm setaf 3
    @echo $1
    @tput -T xterm sgr0
endef
