use Mix.Config

config :exonk8s,
  ecto_repos: [ExOnK8s.Repo]

import_config "#{Mix.env}.exs"
