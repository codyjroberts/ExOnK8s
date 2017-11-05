defmodule ExOnK8s.Router do
  use Plug.Router
  alias ExOnK8s.MusicianController

  plug Plug.Logger
  plug :match
  plug :dispatch

  forward "/musicians", to: MusicianController
  match _, do: send_resp(conn, 404, "not found")
end
