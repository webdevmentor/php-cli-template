.PHONY: install shell stop rebuild clean logs tests help

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

shell: ## Container starten und mit dem PHP-Container verbinden
	docker compose up -d
	docker compose exec -it app bash

stop: ## Container stoppen
	docker compose stop

clean: ## Container entfernen
	docker compose down

_composer-clear-cache:
	docker compose run --rm app composer clear-cache

rebuild: ## Container und Abhängigkeiten vollständig neu bauen
	$(MAKE) stop
	docker compose build --no-cache
	$(MAKE) _composer-clear-cache
	docker compose run --rm app composer install --no-cache

logs: ## Logs anzeigen, optional für einen bestimmten Service
	docker compose logs -f $(SERVICE)

tests: ## Testsuite ausführen
	docker compose exec app composer test
