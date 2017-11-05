defmodule ExOnK8s.Router do
  use Plug.Router

  plug Plug.Logger
  plug :match
  plug :dispatch

  match "/", to: ExOnK8s.Hello
  match _, do: send_resp(conn, 404, "not found")
end
