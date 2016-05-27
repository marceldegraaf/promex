defmodule Promex.GaugeTest do
  use ExUnit.Case

  setup do
    Promex.Registry.register(%Promex.Gauge{name: "foo"})
  end

  test "set" do
    {:ok, value} = Promex.Gauge.set("foo")
    assert value == %Promex.Gauge{name: "foo", value: 1}

    {:ok, value} = Promex.Gauge.set("foo", to: 5)
    assert value == %Promex.Gauge{name: "foo", value: 5}
  end

  test "increment" do
    {:ok, value} = Promex.Gauge.increment("foo")
    assert value == %Promex.Gauge{name: "foo", value: 1}

    {:ok, value} = Promex.Gauge.increment("foo", by: 5)
    assert value == %Promex.Gauge{name: "foo", value: 6}
  end

  test "inc" do
    {:ok, value} = Promex.Gauge.inc("foo")
    assert value == %Promex.Gauge{name: "foo", value: 1}

    {:ok, value} = Promex.Gauge.inc("foo", by: 5)
    assert value == %Promex.Gauge{name: "foo", value: 6}
  end

  test "decrement" do
    {:ok, value} = Promex.Gauge.decrement("foo")
    assert value == %Promex.Gauge{name: "foo", value: -1}

    {:ok, value} = Promex.Gauge.decrement("foo", by: 5)
    assert value == %Promex.Gauge{name: "foo", value: -6}
  end

  test "dec" do
    {:ok, value} = Promex.Gauge.dec("foo")
    assert value == %Promex.Gauge{name: "foo", value: -1}

    {:ok, value} = Promex.Gauge.dec("foo", by: 5)
    assert value == %Promex.Gauge{name: "foo", value: -6}
  end

end
