defmodule Promex.ExporterTest do
  use ExUnit.Case, async: true
  use Plug.Test
  import Mock

  @collect [
    %Promex.Counter{
      name: "foo",
      doc: "this is a counter",
      values: %{
        %{} => 10,
        %{foo: "bar"} => 15
      }
    },
    %Promex.Gauge{
      name: "bar",
      doc: "this is a gauge",
      values: %{
        %{} => 5
      }
    },
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
      foo 10
      foo{foo="bar"} 15
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
