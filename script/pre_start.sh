#!/bin/sh

echo "Waiting for PostgreSQL to start"
until (echo >/dev/tcp/localhost/5432) &>/dev/null; do
  sleep 2
done

if [ "${RUN_MIGRATIONS}" == "true" ]; then
  ./bin/exonk8s migrate
fi;
