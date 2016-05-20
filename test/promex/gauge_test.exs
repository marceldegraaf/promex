defmodule Promex.GaugeTest do
  use ExUnit.Case

  test "set a gauge without a value" do
    assert :ok == Promex.Gauge.set("gauge_test_1")
  end

  test "set a gauge to a value" do
    assert :ok == Promex.Gauge.set("gauge_test_2", 1)
  end
end
