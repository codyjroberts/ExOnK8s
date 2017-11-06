#!/bin/sh

echo "Waiting for PostgreSQL to start"
until (echo >/dev/tcp/localhost/5432) &>/dev/null; do
  sleep 2
done

if [ "${RUN_MIGRATIONS}" == "true" ]; then
  ./bin/exonk8s migrate
fi;

if [ "${RUN_SEEDS}" == "true" ]; then
  if [ "${PG_DATABASE}" != "exonk8s_production" ]; then
    ./bin/exonk8s seed
  else
    (>&2 echo "[WARNING] You tried to seed production!")
  fi;
fi;
