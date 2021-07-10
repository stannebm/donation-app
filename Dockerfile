# ====================================================
# STAGE 1: Elixir build (mix release)

FROM elixir:1.9.0-alpine AS build
RUN apk add --no-cache build-base
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get, deps.compile

# copy prebuilt assets and hash it into a digest
COPY priv priv
RUN mix phx.digest

# compile and build release
COPY lib lib
# uncomment COPY if rel/ exists
# COPY rel rel

RUN mix do compile, release

# ====================================================
# STAGE 2: Production image

# prepare release image
FROM sagittaros/wkhtmltopdf-alpine:latest AS app

WORKDIR /app

# https://unix.stackexchange.com/questions/186568/what-is-nobody-user-and-group#:~:text=The%20nobody%20user%20is%20a,least%20permissions%20on%20the%20system.
# a user with no login permission (least permission)
RUN chown nobody:nobody /app
USER nobody:nobody

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/donation ./
ENV HOME=/app
CMD ["bin/donation", "start"]
