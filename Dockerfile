FROM elixir:1.12-alpine

RUN apk add --no-cache inotify-tools build-base git nodejs npm
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix archive.install hex phx_new --force

RUN mkdir -p /app
COPY . /app
ENV MIX_ENV dev


RUN cd /app && \
    mix do deps.get, compile && \
    npm install --prefix assets


WORKDIR /app
EXPOSE 4000