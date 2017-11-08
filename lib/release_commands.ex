defmodule ExOnK8s.ReleaseCommands do
  @app :exonk8s
  @deps [:logger, :ecto, :postgrex]

  alias ExOnK8s.Repo

  require Logger

  def seed do
    start(@app, @deps)

    seed_script = seed_path(@app)
    if File.exists?(seed_script) do
      Logger.info "running seed script.."
      Code.eval_file(seed_script)
      Logger.info "seeding complete"
    else
      Logger.info "seeding failed"
    end


    stop()
  end

  def migrate do
    start(@app, @deps)

    Logger.info "migrating database..."
    Ecto.Migrator.run(Repo, migrations_path(@app), :up, all: true)

    stop()
  end

  defp start(app, deps) do
    :ok = Application.load(app)
    Enum.each(deps, &start_dep/1)

    app
    |> Application.get_env(:ecto_repos, [])
    |> Enum.each(&(&1.start_link(pool_size: 1)))
  end

  defp start_dep(dep), do: {:ok, _} = Application.ensure_all_started(dep)

  defp stop, do: :init.stop()

  defp migrations_path(app), do: Path.join([priv_dir(app), "repo", "migrations"])

  defp seed_path(app), do: Path.join([priv_dir(app), "repo", "seeds.exs"])

  defp priv_dir(app), do: "#{:code.priv_dir(app)}"
end
