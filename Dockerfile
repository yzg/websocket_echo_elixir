
# build stage

FROM elixir:1.18 AS build

RUN apt-get update && apt-get install -y build-essential git

WORKDIR /app

COPY mix.exs ./

RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get && \
    mix deps.compile

COPY lib ./lib
RUN MIX_ENV=prod mix compile
RUN MIX_ENV=prod mix release

#

FROM debian:bookworm-slim AS app

WORKDIR /app

COPY --from=build /app/_build/prod/rel/websocket_echo ./

RUN apt-get update && \
    apt-get install -y libstdc++6 libncurses6 openssl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV PORT=4000
EXPOSE 4000

CMD ["bin/websocket_echo", "start"]
