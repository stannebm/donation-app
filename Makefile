# `make`. This builds and run the system
default:
	docker-compose up -d --build

# create an external network that can be shared later
network:
	docker network create donation_net

# run migration
migrate:
	docker-compose exec phoenix bin/donation eval "Donation.Release.migrate"

# starts an IEX shell attached to current system
iex:
	docker-compose exec phoenix bin/donation remote