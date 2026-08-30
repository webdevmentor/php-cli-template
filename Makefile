.PHONY: install start stop restart rebuild attach logs tests help

help: ## Diese Hilfe anzeigen
	@echo "Usage:"
	@echo "  make <target>"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  %-12s %s\n", $$1, $$2}'

install: .env ## Entwicklungsumgebung initialisieren
	docker compose build
	docker compose run --rm app composer install
	$(MAKE) stop

.env:
	cp .env.example .env

start: ## Entwicklungsumgebung starten
	docker compose up -d
	$(MAKE) attach

stop: ## Entwicklungsumgebung stoppen
	docker compose down

_composer-clear-cache:
	docker compose run --rm app composer clear-cache

restart: ## Entwicklungsumgebung neu starten
	$(MAKE) stop
	$(MAKE) start

rebuild: ## Container und Abhängigkeiten vollständig neu bauen
	$(MAKE) stop
	docker compose build --no-cache
	$(MAKE) _composer-clear-cache
	docker compose run --rm app composer install
	$(MAKE) start

attach: ## Mit dem PHP-Container verbinden
	docker compose exec -it app bash

logs: ## Logs anzeigen, optional für einen bestimmten Service
	docker compose logs -f $(SERVICE)

tests: ## Testsuite ausführen
	docker compose exec app composer test
