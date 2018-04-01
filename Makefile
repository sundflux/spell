.PHONY: help
.DEFAULT_GOAL := help

#test-latest: ## Test creating a project with the latest release (1.0.0)
#	$(call colorecho, "\n- Do something...\n")
#	composer create-project druidfi/spell /tmp/mysite/1.0.0 1.0.0 --no-interaction

test-master: ## Test creating a project with the master branch
	$(call colorecho, "\n- Do something...\n")
	composer create-project druidfi/spell:dev-master /tmp/mysite/master --no-interaction

help: ## Print this help
	$(call colorecho, "\nAvailable make commands:\n")
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo ""

define colorecho
    @tput -T xterm setaf 3
    @echo $1
    @tput -T xterm sgr0
endef
