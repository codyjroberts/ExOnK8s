use Mix.Config

config :logger, :console,
  level: :info

config :exonk8s, ExOnK8s.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "${PG_USERNAME}",
  password: "${PG_PASSWORD}",
  database: "${PG_DATABASE}",
  hostname: "${PG_HOSTNAME}",
  port: 5432,
  pool_size: 10
