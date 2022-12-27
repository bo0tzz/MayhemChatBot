FROM bitwalker/alpine-elixir:latest AS build

ENV MIX_ENV=prod

WORKDIR /build/

COPY . .
RUN mix deps.get --only prod
RUN mix release

FROM bitwalker/alpine-elixir:latest AS run

COPY --from=build /build/_build/prod/rel/mayhem_chatbot/ ./
RUN chmod +x ./bin/mayhem_chatbot
CMD ./bin/mayhem_chatbot start

