defmodule Promex.CounterTest do
  use ExUnit.Case

  setup do
    Promex.Registry.register(%Promex.Counter{name: "foo"})
  end

  test "increment" do
    {:ok, value} = Promex.Counter.increment("foo")
    assert value == %Promex.Counter{name: "foo", values: %{%{} => 1}}

    {:ok, value} = Promex.Counter.increment("foo", by: 2)
    assert value == %Promex.Counter{name: "foo", values: %{%{} => 3}}

    {:ok, value} = Promex.Counter.increment("foo", labels: %{status: 200})
    assert value == %Promex.Counter{name: "foo", values: %{%{} => 3, %{status: 200} => 1}}

    {:ok, value} = Promex.Counter.increment("foo", by: 2, labels: %{status: 200})
    assert value == %Promex.Counter{name: "foo", values: %{%{} => 3, %{status: 200} => 3}}

    {:error, msg} = Promex.Counter.increment("foo", by: -1, labels: %{})
    assert msg == "increment must be a non-negative number"

    {:error, msg} = Promex.Counter.increment("foo", by: "A", labels: %{})
    assert msg == "increment must be a number"
  end

  test "inc" do
    {:ok, value} = Promex.Counter.inc("foo")
    assert value == %Promex.Counter{name: "foo", values: %{%{} => 1}}

    {:ok, value} = Promex.Counter.inc("foo", by: 2)
    assert value == %Promex.Counter{name: "foo", values: %{%{} => 3}}

    {:ok, value} = Promex.Counter.inc("foo", labels: %{status: 200})
    assert value == %Promex.Counter{name: "foo", values: %{%{} => 3, %{status: 200} => 1}}

    {:ok, value} = Promex.Counter.inc("foo", by: 2, labels: %{status: 200})
    assert value == %Promex.Counter{name: "foo", values: %{%{} => 3, %{status: 200} => 3}}

    {:error, msg} = Promex.Counter.inc("foo", by: -1, labels: %{})
    assert msg == "increment must be a non-negative number"

    {:error, msg} = Promex.Counter.inc("foo", by: "A", labels: %{})
    assert msg == "increment must be a number"
  end

end
