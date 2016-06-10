defmodule Promex.MetricTest do
  use ExUnit.Case

  test "determine type" do
    assert Promex.Metric.type(%Promex.Counter{}) == "counter"
    assert Promex.Metric.type(%Promex.Gauge{}) == "gauge"

    assert_raise ArgumentError, "foo is not a valid metric type", fn ->
      Promex.Metric.type("foo")
    end
  end
end
