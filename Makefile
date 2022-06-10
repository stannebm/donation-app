# ----------------------------------------------------------------------------
# Deploy
# ----------------------------------------------------------------------------

default: build-assets
	docker --context stanne compose up -d --build

legacy-default: build-assets
	docker-compose up -d --build

build-assets:
	rm -rf priv/static
	cd assets && yarn exec snowpack build

# run migration
migrate:
	docker-compose exec phoenix bin/donation eval "Donation.Release.migrate"

remote-context:
	docker context create \
    --docker host=ssh://sammy@188.166.248.78 \
    stanne


# ----------------------------------------------------------------------------
# Dev
# ----------------------------------------------------------------------------

dev: generate-swagger
	mix phx.server

generate-swagger:
	mix phx.swagger.generate

upgrade-package-json:
	cd assets && yarn yarn-upgrade-all

# ----------------------------------------------------------------------------
# Debugging
# ----------------------------------------------------------------------------

# starts an IEX shell attached to current system
iex:
	docker-compose exec phoenix bin/donation remote

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
