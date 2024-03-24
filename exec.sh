#!/usr/bin/env bash

docker compose exec wp wp-cli core install --url="http://localhost:8181" --title="Caritas-Vilnius" --admin_user="robertas" --admin_email="robertas.grajevskis@gmail.com"
docker compose exec wp wp-cli plugin delete akismet
docker compose exec wp wp-cli plugin delete hello
docker compose exec wp wp-cli theme activate caritas-vilnius-theme