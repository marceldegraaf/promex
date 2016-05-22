defmodule Promex.CounterTest do
  use ExUnit.Case
  doctest Promex.Counter

  test "aliases increment function to inc" do
    {:ok, value} = Promex.Counter.inc("test_counter_alias")
    assert value == 1

    {:ok, value} = Promex.Counter.inc("test_counter_alias", by: 2)
    assert value == 3
  end
end
