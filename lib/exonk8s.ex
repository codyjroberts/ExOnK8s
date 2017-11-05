defmodule ExOnK8s do
  use Application
  import Supervisor.Spec
  alias ExOnK8s.{Router, Repo}

  def start(_type, _args) do
    children = [
      supervisor(Repo, []),
      Plug.Adapters.Cowboy.child_spec(:http, Router, [], [port: 4001])
    ]

    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)
  end
end
