defmodule ExOnK8s.Router do
  use Plug.Router

  plug Plug.Logger
  plug :match
  plug :dispatch

  match "/", do: send_resp(conn, 200, "hello")
  match _, do: send_resp(conn, 404, "not found")
end
