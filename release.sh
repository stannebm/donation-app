#!/bin/bash

# THIS FILE IS USED FOR DEVELOPMENT PURPOSE ONLY
# DO NOT USE IT IN DOCKERIZED ENVIRONMENT 
# FOR PROPER RELEASE, refer:
# https://hexdocs.pm/phoenix/releases.html
# https://hexdocs.pm/mix/Mix.Tasks.Release.html
# - Felix

export SECRET_KEY_BASE="$(mix phx.gen.secret)"
echo $SECRET_KEY_BASE

# on development machine
export DATABASE_URL=ecto://postgres:postgres@localhost/donation_prod

mix deps.get --only prod
MIX_ENV=prod mix compile

# compile assets with snowpack
yarn --cwd ./assets make 
mix phx.digest

# This creates a standalone release
MIX_ENV=prod mix release



