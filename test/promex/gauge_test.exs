defmodule Promex.GaugeTest do
  use ExUnit.Case
  doctest Promex.Gauge

  test "aliases increment function to inc" do
    {:ok, value} = Promex.Gauge.inc("test_gauge_inc_alias_1")
    assert value == 1

    {:ok, value} = Promex.Gauge.inc("test_gauge_inc_alias_1", by: 3)
    assert value == 4
  end

  test "aliases decrement function to dec" do
    {:ok, value} = Promex.Gauge.dec("test_gauge_dec_alias_1")
    assert value == -1

    {:ok, value} = Promex.Gauge.dec("test_gauge_dec_alias_1", by: 3)
    assert value == -4
  end
end
