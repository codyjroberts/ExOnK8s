defmodule ExOnK8s do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      Plug.Adapters.Cowboy.child_spec(:http, ExOnK8s.Router, [], [port: 4001])
    ]

    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)
  end
end
