defmodule ExOnK8s.Foo do
  @on_load :on_load

  require Logger

  def on_load do
    IO.puts "Foo Loaded"
    :ok
  end

  def lazy do
    Logger.info "Lazy called"
  end
end
