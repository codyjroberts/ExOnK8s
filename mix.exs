defmodule ExOnK8s.Mixfile do
  use Mix.Project

  def project do
    [
      app: :exonk8s,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {ExOnK8s, []}
    ]
  end

  defp deps do
    [
      {:cowboy, "~> 1.1.0"},
      {:plug, "~> 1.4"}
    ]
  end
end
