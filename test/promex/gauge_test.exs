defmodule Promex.GaugeTest do
  use ExUnit.Case
  import Mock

  doctest Promex.Gauge

  setup do
    Promex.Registry.register(%Promex.Gauge{name: "foo"})
  end

  test "set" do
    {:ok, value} = Promex.Gauge.set("foo")
    assert value == %Promex.Gauge{name: "foo", values: %{%{} => 1}}

    {:ok, value} = Promex.Gauge.set("foo", to: 5)
    assert value == %Promex.Gauge{name: "foo", values: %{%{} => 5}}

    {:error, msg} = Promex.Gauge.set("foo", to: "A")
    assert msg == "value must be a number"
  end

  test "set_to_current_time" do
    with_mock Timex, [to_unix: fn(_time) -> 62167219200 end] do
      {:ok, value} = Promex.Gauge.set_to_current_time("foo")
      assert value == %Promex.Gauge{name: "foo", values: %{%{} => 62167219200}}
    end
  end

  test "increment" do
    {:ok, value} = Promex.Gauge.increment("foo")
    assert value == %Promex.Gauge{name: "foo", values: %{%{} =>1}}

    {:ok, value} = Promex.Gauge.increment("foo", by: 5)
    assert value == %Promex.Gauge{name: "foo", values: %{%{} => 6}}

    {:error, msg} = Promex.Gauge.increment("foo", by: "A")
    assert msg == "increment must be a number"
  end

  test "inc" do
    {:ok, value} = Promex.Gauge.inc("foo")
    assert value == %Promex.Gauge{name: "foo", values: %{%{} => 1}}

    {:ok, value} = Promex.Gauge.inc("foo", by: 5)
    assert value == %Promex.Gauge{name: "foo", values: %{%{} => 6}}

    {:error, msg} = Promex.Gauge.increment("foo", by: "A")
    assert msg == "increment must be a number"
  end

  test "decrement" do
    {:ok, value} = Promex.Gauge.decrement("foo")
    assert value == %Promex.Gauge{name: "foo", values: %{%{} => -1}}

    {:ok, value} = Promex.Gauge.decrement("foo", by: 5)
    assert value == %Promex.Gauge{name: "foo", values: %{%{} => -6}}

    {:error, msg} = Promex.Gauge.decrement("foo", by: "A")
    assert msg == "decrement must be a number"
  end

  test "dec" do
    {:ok, value} = Promex.Gauge.dec("foo")
    assert value == %Promex.Gauge{name: "foo", values: %{%{} => -1}}

    {:ok, value} = Promex.Gauge.dec("foo", by: 5)
    assert value == %Promex.Gauge{name: "foo", values: %{%{} => -6}}

    {:error, msg} = Promex.Gauge.dec("foo", by: "A")
    assert msg == "decrement must be a number"
  end

end
