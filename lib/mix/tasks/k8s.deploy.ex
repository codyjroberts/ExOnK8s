defmodule Mix.Tasks.K8s.Deploy do
  @shortdoc "Deploys release image at current git commit SHA"
  @moduledoc """
  Deploys release image at given SHA or current git commit SHA by default.
  Pass undo to rollback.
      mix k8s.deploy [undo, SHA]
  """

  use Mix.Task
  alias Mix.Project

  @app Atom.to_string(Project.config[:app])

  def run(args) do
    {_opts, args, _} = OptionParser.parse(args)

    case args do
      [] -> deploy(local_sha())
      ["undo"] -> rollback()
      [sha] -> deploy(sha)
      _ ->
        Mix.raise "Invalid arguments, expected: mix k8s.deploy [undo, SHA]"
    end
  end

  defp commits_since_last_deploy(sha) do
    pretty("commits since last deploy")

    if valid_sha?(sha) do
      System.cmd("git", [
        "log",
        "--format=short",
        "#{deployed_sha()}..HEAD",
        "--reverse",
      ], into: IO.stream(:stdio, :line))
    else
      Mix.Shell.IO.info("Unabled to diff commits")
      Mix.Shell.IO.info("Deployed tag `#{deployed_sha()}` is not a valid SHA")
    end
  end

  defp rollback do
    pretty("rolling back to")
    System.cmd("kubectl", [
      "rollout",
      "undo",
      "deployment/#{@app}",
      "--dry-run=true"
    ], into: IO.stream(:stdio, :line))

    unless proceed?() do exit(:aborted) end

    System.cmd("kubectl", [
      "rollout",
      "undo",
      "deployment/#{@app}"
    ])

    pretty("rolled back to")
    System.cmd("git", [
      "log",
      "--format=short",
      "-1"
    ], into: IO.stream(:stdio, :line))
  end

  defp deploy(sha) do
    unless valid_sha?(sha) do exit(:invalid_sha) end

    commits_since_last_deploy(sha)

    unless proceed?() do exit(:aborted) end

    System.cmd("docker", [
      "tag",
      "#{@app}:#{sha}",
      "#{@app}:latest",
    ], into: IO.stream(:stdio, :line))

    System.cmd("kubectl", [
      "set",
      "image",
      "deployments",
      @app,
      "#{@app}=#{@app}:#{sha}",
    ], into: IO.stream(:stdio, :line))

    case System.cmd("kubectl", ["config", "current-context"]) do
      {"minikube\n", _} -> minikube_url()
      _ -> nil
    end
  end

  defp proceed? do
    Mix.Shell.IO.yes?("\n\nDo you wish to proceed?")
  end

  defp minikube_url do
    pretty("Running at")

    System.cmd("minikube", [
      "service",
      @app,
      "--url"
    ], into: IO.stream(:stdio, :line))
  end

  defp local_sha do
    "git"
    |> System.cmd(["rev-parse", "HEAD"])
    |> elem(0)
    |> String.trim
  end

  defp deployed_sha do
    {image, _} =
      System.cmd("kubectl", [
        "get",
        "deployment",
        @app,
        "-o=jsonpath='{$.spec.template.spec.containers[:1].image}'"
      ])

    ~r/:(\w*)/
    |> Regex.run(image, capture: :all_but_first)
    |> List.first
  end

  defp pretty(header) when is_binary(header) do
    header_length = String.length(header)
    break = String.duplicate("-", header_length)

    Mix.Shell.IO.info("")
    IO.puts IO.ANSI.format([:red, :bright, String.upcase(header)])
    IO.puts IO.ANSI.format([:red, :bright, break])
  end

  defp valid_sha?(sha) do
    {_, exit_status} =
      System.cmd("git", [
        "rev-parse",
        "--quiet",
        "--verify",
        "#{sha}^{commit}"
      ])

    exit_status == 0
  end
end
