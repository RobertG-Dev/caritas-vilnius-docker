DOCKER_COMPOSE := docker compose

.PHONY: all

all: composer-install start

start:
	$(DOCKER_COMPOSE) up -d

stop:
	docker compose stop
