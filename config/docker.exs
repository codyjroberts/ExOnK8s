use Mix.Config

# Configures Elixir's Logger
config :logger, :console,
  level: :debug

config :exonk8s, ExOnK8s.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "exonk8s_dev",
  username: "postgres",
  password: "postgres",
  hostname: "db"
