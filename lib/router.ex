defmodule ExOnK8s.Router do
  use Plug.Router
  alias ExOnK8s.MusicianController

  plug Plug.Logger
  plug :match
  plug :dispatch

  forward "/musicians", to: MusicianController
  match "/", do: send_resp(conn, 200, ~s(<a href="/musicians">musicians</a>))
  match _, do: send_resp(conn, 404, "not found")
end
