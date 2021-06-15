# `make`. This builds and run the system
default:
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
