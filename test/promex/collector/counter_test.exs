defmodule Promex.Collector.CounterTest do
  use ExUnit.Case, async: true

  test "creates a new counter with initial value 1" do
    {:noreply, state} = Promex.Collector.handle_cast({:counter, :increment, "foo", [by: 1]}, %{})
    assert state == %{"foo" => 1}
  end

  test "creates a new counter with initial value 10" do
    {:noreply, state} = Promex.Collector.handle_cast({:counter, :increment, "foo", [by: 10]}, %{})
    assert state == %{"foo" => 10}
  end

  test "increments an existing counter by 1" do
    {:noreply, state} = Promex.Collector.handle_cast({:counter, :increment, "foo", [by: 1]}, %{"foo" => 1})
    assert state == %{"foo" => 2}
  end

  test "increments an existing counter by 10" do
    {:noreply, state} = Promex.Collector.handle_cast({:counter, :increment, "foo", [by: 10]}, %{"foo" => 1})
    assert state == %{"foo" => 11}
  end

end
