PHONY :=
.DEFAULT_GOAL := help

#test-latest: ## Test creating a project with the latest release (1.0.0)
#	$(call colorecho, "\n- Do something...\n")
#	composer create-project druidfi/spell /tmp/mysite/1.0.0 1.0.0 --no-interaction

PHONY += test-master
test-master: ## Test creating a project with the master branch
	mkdir -p ~/_tests/mysite
	rm -rf ~/_tests/mysite/master
	$(call colorecho, "\n- Test creating a project using master branch...\n")
	composer create-project druidfi/spell:dev-master ~/_tests/mysite/master --no-interaction

PHONY += help
help: ## Print this help
	$(call colorecho, "\nAvailable make commands:")
	@cat $(MAKEFILE_LIST) | grep -e "^[a-zA-Z_\-]*: *.*## *" | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

define colorecho
    @tput -T xterm setaf 3
    @echo $1
    @tput -T xterm sgr0
endef

.PHONY: $(PHONY)
