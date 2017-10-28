defmodule Example.RouterTest do
  use ExUnit.Case
  use Plug.Test

  alias ExOnK8s.Router

  @opts Router.init([])

  test "returns hello" do
    conn =
      :get
      |> conn("/")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "hello"
  end

  test "returns 404" do
    conn =
      :get
      |> conn("/invalid")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 404
  end
end
