defmodule Promex.CounterTest do
  use ExUnit.Case

  setup do
    Promex.Registry.register(%Promex.Counter{name: "foo"})
  end

  test "increment" do
    {:ok, value} = Promex.Counter.increment("foo")
    assert value == %Promex.Counter{name: "foo", value: 1}

    {:ok, value} = Promex.Counter.increment("foo", by: 2)
    assert value == %Promex.Counter{name: "foo", value: 3}

    {:error, msg} = Promex.Counter.increment("foo", by: -1)
    assert msg == "increment must be a non-negative number"

    {:error, msg} = Promex.Counter.increment("foo", by: "A")
    assert msg == "increment must be a number"
  end

  test "inc" do
    {:ok, value} = Promex.Counter.inc("foo")
    assert value == %Promex.Counter{name: "foo", value: 1}

    {:ok, value} = Promex.Counter.inc("foo", by: 2)
    assert value == %Promex.Counter{name: "foo", value: 3}
  end

end
