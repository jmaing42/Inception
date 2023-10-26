all: up
.PHONY: up

.PHONY: all
all:
	$(MAKE) init
	$(MAKE) up

.PHONY: init
init: .intra_login.txt prelude
	@[ -t 0 ] || echo "You MUST set hostname manually!"
	@[ ! -t 0 ] || printf "\033[33mYou MUST set hostname manually!\033[0m\n"
	[ -f .intra_login.txt ] && mkdir -p "/home/$$(cat .intra_login.txt)/data/mariadb" "/home/$$(cat .intra_login.txt)/data/wordpress"

.intra_login.txt:
	@sh -c 'printf "Enter intra login > " && IFS= read -r INTRA_LOGIN && printf "%s" "$${INTRA_LOGIN}" > $@ && ([ "$$(cat $@)" != "" ] || printf "%s" "$$(whoami)" > $@)'

.PHONY: clean
clean:
	@sh -c 'echo "clean without fclean may result in the persistence of volume data. Press Enter to continue, or Ctrl+C to stop." && IFS= read -r UNUSED'
	rm -f .intra_login.txt srcs/.env

.PHONY: fclean
fclean:
	[ ! -f .intra_login.txt ] || rm -rf "/home/$$(cat .intra_login.txt)/data/mariadb" "/home/$$(cat .intra_login.txt)/data/wordpress"
	rm -f .intra_login.txt srcs/.env

.PHONY: re
re:
	$(MAKE) fclean
	$(MAKE) all

.PHONY: up
up: prelude
	docker compose --env-file ./srcs/.env -f ./src/docker-compose.yml up -d

.PHONY: down
down: prelude
	docker compose --env-file ./srcs/.env -f ./src/docker-compose.yml $@

.PHONY: prelude
prelude: ./srcs/.env

./srcs/.env:
	@sh ./src/init.sh

.PHONY: dev
dev: prelude
	@docker compose --env-file ./srcs/.env -f ./src/docker-compose.yml down -v
	@docker compose --env-file ./srcs/.env -f ./src/docker-compose.yml up -d --build
