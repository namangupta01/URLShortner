#!/bin/sh

if [ "$DATABASE" = "postgres" ]
then
    echo "Waiting for postgres..."

    while ! nc -z "$URL_SHORTENER_DATABASE_HOST" 5432; do
      sleep 0.1
    done

    echo "PostgreSQL started"
fi

echo "PostgreSQL started"

bundle exec rake db:migrate

exec "$@"
