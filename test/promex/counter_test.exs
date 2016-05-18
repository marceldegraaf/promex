defmodule Promex.CounterTest do
  use ExUnit.Case

  test "increment a counter" do
    assert :ok == Promex.Counter.increment("counter_test_1")
  end
end
