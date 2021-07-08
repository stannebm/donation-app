# `make`. This builds and run the system
default:
	yarn --cwd ./assets make
	docker-compose up -d --build

# create an external network that can be shared later. (one time)
network:
	docker network create donation_net

# # Setup reverse proxy with SSL
# caddy:
# 	docker-compose -f docker-compose.caddy.yml up -d --build

# run migration
migrate:
	docker-compose exec phoenix bin/donation eval "Donation.Release.migrate"

# starts an IEX shell attached to current system
iex:
	docker-compose exec phoenix bin/donation remote

dev: generate-swagger
	mix phx.server

generate-swagger:
	mix phx.swagger.generate

shell:
	docker-compose exec phoenix sh

psql:
	docker-compose exec db \
		psql postgres://postgres:postgres@db/donation_db

pg_dump:
	docker-compose exec db \
		pg_dump postgres://postgres:postgres@db/donation_db \
		> "$(shell date +%Y%m%d)-dump.sql"

log:
	ssh arch "journalctl CONTAINER_NAME=donation-app_phoenix_1"
