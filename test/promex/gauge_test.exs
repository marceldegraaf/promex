defmodule Promex.GaugeTest do
  use ExUnit.Case
  import Mock

  doctest Promex.Gauge

  setup do
    Promex.Registry.register(%Promex.Gauge{name: "foo"})
  end

  test "set" do
    {:ok, value} = Promex.Gauge.set("foo")
    assert value == %Promex.Gauge{name: "foo", value: 1}

    {:ok, value} = Promex.Gauge.set("foo", to: 5)
    assert value == %Promex.Gauge{name: "foo", value: 5}
  end

  test "set_to_current_time" do
    with_mock Timex, [to_unix: fn(_time) -> 62167219200 end] do
      {:ok, value} = Promex.Gauge.set_to_current_time("foo")
      assert value == %Promex.Gauge{name: "foo", value: 62167219200}
    end
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
