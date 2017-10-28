FROM bitwalker/alpine-elixir:1.5.2 as builder

ENV HOME=/opt/app/ TERM=xterm

# Install Hex+Rebar
RUN mix local.hex --force && \
    mix local.rebar --force

WORKDIR /opt/app

ENV MIX_ENV=prod

# Cache elixir deps
COPY mix.* ./
COPY config ./config

RUN mix deps.get --only prod
RUN mix deps.compile

COPY . .

RUN mix compile
RUN mix release --env=prod --verbose

FROM bitwalker/alpine-elixir:1.5.2

ARG VRSN

ENV MIX_ENV=prod

RUN apk update && \
    apk --no-cache --update add bash libgcc libstdc++ && \
    rm -rf /var/cache/apk/*

WORKDIR /app

COPY --from=builder /opt/app/_build/prod/rel/exonk8s/releases/$VRSN/exonk8s.tar.gz ./
RUN tar xvf exonk8s.tar.gz

EXPOSE 4001
# EXPOSE 5432
ENV PORT=4001 MIX_ENV=prod REPLACE_OS_VARS=true SHELL=/bin/sh

ENTRYPOINT ["bin/exonk8s"]
