defmodule Mix.Tasks.Docker.Build do
  @shortdoc "Builds Erlang release Docker image"
  @moduledoc """
  Builds Erlang release Docker image
    mix docker.build
  """

  use Mix.Task
  alias Mix.Project

  def run(args) do
    {_opts, args, _} = OptionParser.parse(args)

    case args do
      [] -> build()
      _ ->
        Mix.raise "Invalid arguments, expected: mix docker.build"
    end
  end

  def build do
    app_name =
      Project.config[:app]
      |> Atom.to_string()

    sha =
      "git"
      |> System.cmd(["rev-parse", "HEAD"])
      |> elem(0)
      |> String.trim

    System.cmd("docker", [
      "build",
      "--build-arg",
      "VRSN=#{Project.config[:version]}",
      "-t",
      "#{app_name}:#{sha}",
      "."
    ], into: IO.stream(:stdio, :line), env: [{"MIX_ENV", "prod"}])

    System.cmd("docker", [
      "tag",
      "#{app_name}:#{sha}",
      "#{app_name}:latest",
    ], into: IO.stream(:stdio, :line))
  end
end
