defmodule ExOnK8s.MusicianController do
  import Plug.Conn
  alias ExOnK8s.{Repo, Musician}

  def init(opts), do: opts

  def call(conn, _opts), do: route(conn.method, conn.path_info, conn)

  def route("GET", [], conn) do
    ExOnK8s.Foo.lazy() # Demonstrate lazy loading

    musicians =
      Musician
      |> Repo.all()
      |> Poison.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, musicians)
  end

  def route("GET", [id], conn) do
    musician =
      Musician
      |> Repo.get(String.to_integer(id))
      |> Poison.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, musician)
  end
end
