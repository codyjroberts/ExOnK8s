defmodule ExOnK8s.ReleaseCommands do
  @app :exonk8s
  @deps [:logger]

  require Logger

  def seed do
    start(@app, @deps)
    Logger.info "seeding database..."
    stop()
  end

  def migrate do
    start(@app, @deps)
    Logger.info "migrating database..."
    stop()
  end

  defp start(app, deps) do
    :ok = Application.load(app)
    Enum.each(deps, &start_dep/1)
  end

  defp stop, do: :init.stop()

  defp start_dep(dep), do: {:ok, _} = Application.ensure_all_started(dep)
end
