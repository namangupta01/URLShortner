# Dockerfile
FROM ruby:2.7-alpine

RUN apk update && apk add build-base ruby-dev nodejs postgresql-dev

WORKDIR /app
COPY . /app
RUN bundle install

ENTRYPOINT ["/app/entrypoint.sh"]
