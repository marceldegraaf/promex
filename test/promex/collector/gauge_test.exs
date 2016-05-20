defmodule Promex.Collector.GaugeTest do
  use ExUnit.Case, async: true

  test "creates a new gauge with initial value 1" do
    {:noreply, state} = Promex.Collector.handle_cast({:gauge, :set, "foo", 1}, %{})
    assert state == %{"foo" => 1}
  end

  test "creates a new gauge with initial value 10" do
    {:noreply, state} = Promex.Collector.handle_cast({:gauge, :set, "foo", 10}, %{})
    assert state == %{"foo" => 10}
  end

  test "updates an existing gauge" do
    {:noreply, state} = Promex.Collector.handle_cast({:gauge, :set, "foo", 10}, %{})
    assert state == %{"foo" => 10}

    {:noreply, state} = Promex.Collector.handle_cast({:gauge, :set, "foo", 5}, %{"foo" => 10})
    assert state == %{"foo" => 5}
  end

end
