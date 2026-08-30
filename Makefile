.PHONY: install start stop attach logs tests help

help: ## Show this help
	@echo "Usage:"
	@echo "  make <target>"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  %-12s %s\n", $$1, $$2}'

install: .env ## Initialize the development environment
	docker compose build
	docker compose run --rm app composer install
	$(MAKE) stop

.env:
	cp .env.example .env

start: ## Start the development environment
	docker compose up -d
	$(MAKE) attach

stop: ## Stop the development environment
	docker compose down

attach: ## Attach to the PHP container
	docker compose exec -it app bash

logs: ## Show logs, optionally for a specific service
	docker compose logs -f $(SERVICE)

tests: ## Run the test suite
	docker compose exec app composer test
