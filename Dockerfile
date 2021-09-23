FROM elixir:alpine

RUN mkdir /app
COPY . /app
WORKDIR /app

RUN apk add --update nodejs && apk add --update npm


EXPOSE 4000

RUN mix local.hex --force && mix local.rebar --force

RUN cd ./assets && npm install && node node_modules/webpack/bin/webpack.js && cd ..

RUN mix do deps.get, deps.compile

CMD ["mix", "phx.server"]