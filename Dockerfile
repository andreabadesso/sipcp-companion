# Build stage
FROM hexpm/elixir:1.17.2-erlang-27.0.1-debian-bookworm-20240701 AS build

RUN apt-get update -y && apt-get install -y build-essential git curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN mix local.hex --force && mix local.rebar --force

ENV MIX_ENV=prod

# Install deps
COPY mix.exs mix.lock ./
RUN mix deps.get --only prod
RUN mkdir config
COPY config/config.exs config/prod.exs config/runtime.exs config/
RUN mix deps.compile

# Copy source
COPY assets assets
COPY priv priv
COPY lib lib

# Compile first (generates colocated hooks for esbuild)
RUN mix compile

# Then build assets
RUN mix assets.deploy

# Build release
RUN mix release

# Runtime stage
FROM debian:bookworm-slim AS app

RUN apt-get update -y && \
    apt-get install -y libstdc++6 openssl libncurses5 locales ca-certificates curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

WORKDIR /app

RUN useradd --create-home app
COPY --from=build --chown=app:app /app/_build/prod/rel/sipcp_companion ./

# Copy book data for RAG ingest
COPY --chown=app:app book/ocr/pages ./book/ocr/pages
COPY --chown=app:app priv/repo/ingest_book.exs ./priv/repo/ingest_book.exs

USER app

ENV PHX_SERVER=true
EXPOSE 4000

HEALTHCHECK --interval=15s --timeout=5s --start-period=30s --retries=3 \
  CMD curl -f http://localhost:4000/ || exit 1

CMD ["bin/sipcp_companion", "start"]
