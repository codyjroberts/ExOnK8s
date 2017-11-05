defmodule ExOnK8s.Hello do
  import Plug.Conn

  def init(options), do: options

  def call(conn, _opts) do
    ExOnK8s.Foo.lazy()

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Hello")
  end
end
