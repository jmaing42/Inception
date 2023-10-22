all: up
.PHONY: up

.PHONY: up
up: prelude
	docker compose --env-file ./srcs/.env -f ./src/docker-compose.yml up -d

.PHONY: down
down: prelude
	docker compose --env-file ./srcs/.env -f ./src/docker-compose.yml $@

.PHONY: prelude
prelude: ./srcs/.env
    sh ./src/init.sh
