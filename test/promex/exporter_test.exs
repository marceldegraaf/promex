defmodule Promex.ExporterTest do
  use ExUnit.Case, async: true
  use Plug.Test
  import Mock

  @collect [
    %Promex.Counter{name: "foo", value: 3, doc: "this is a counter", labels: %{foo: "bar", baz: "bax"}},
    %Promex.Gauge{name: "bar", value: 5, doc: "this is a gauge"},
  ]

  test "returns parsed metrics" do
    with_mock Promex.Registry, [collect: fn(:default) -> @collect end] do
      conn = conn(:get, "/metrics")
      conn = Promex.Exporter.call(conn, [])

      assert conn.state == :sent
      assert conn.status == 200
      assert conn.resp_body == """
      TYPE bar gauge
      HELP bar this is a gauge
      bar 5
      TYPE foo counter
      HELP foo this is a counter
      foo{baz="bax",foo="bar"} 3
      """
    end
  end

  test "does not error on /favicon.ico request" do
    with_mock Promex.Registry, [collect: fn(:default) -> @collect end] do
      conn = conn(:get, "/favicon.ico")
      conn = Promex.Exporter.call(conn, [])

      assert conn.state == :sent
      assert conn.status == 404
      assert conn.resp_body == "Not Found"
    end
  end
end
