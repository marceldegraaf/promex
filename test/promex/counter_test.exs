defmodule Promex.CounterTest do
  use ExUnit.Case

  test "uses 1 as default value for new counters" do
    Promex.Counter.increment("foo")
    assert Promex.Collector.metrics["foo"] == 1
  end

  #  test "increments a counter by a given value" do
  #    Promex.Counter.increment("foo", by: 10)
  #    assert Promex.Collector.metrics["foo"] == 10
  #  end
end
