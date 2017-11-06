defmodule ExOnK8s.Mixfile do
  use Mix.Project

  def project do
    [
      app: :exonk8s,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  def application do
    [
      mod: {ExOnK8s, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp deps do
    [
      {:cowboy, "~> 1.1.0"},
      {:plug, "~> 1.4"},
      {:postgrex, "~> 0.13.0"},
      {:ecto, "~> 2.2"},
      {:poison, "~> 3.1"},
      {:distillery, "~> 1.4", runtime: false}
    ]
  end

  defp aliases do
    [
      shipit: ["docker.build", "k8s.deploy"]
    ]
  end
end
