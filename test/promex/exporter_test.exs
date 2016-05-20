defmodule Promex.ExporterTest do
  use ExUnit.Case, async: true
  use Plug.Test
  import Mock

  @state %{
    "foo" => 1
  }

  test "returns parsed metrics" do
    with_mock Promex.Collector, [metrics: fn -> @state end] do
      conn = conn(:get, "/metrics")
      conn = Promex.Exporter.call(conn, [])

      assert conn.state == :sent
      assert conn.status == 200
      assert conn.resp_body == "foo 1\n"
    end
  end

  test "does not error on /favicon.ico request" do
    with_mock Promex.Collector, [metrics: fn -> @state end] do
      conn = conn(:get, "/favicon.ico")
      conn = Promex.Exporter.call(conn, [])

      assert conn.state == :sent
      assert conn.status == 404
      assert conn.resp_body == "Not Found"
    end
  end
end
