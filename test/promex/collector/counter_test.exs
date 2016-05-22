defmodule Promex.Collector.CounterTest do
  use ExUnit.Case, async: true

  test "creates a new counter with initial value 1" do
    {:reply, reply, state} = Promex.Collector.handle_call({:counter, :increment, "foo", [by: 1]}, nil, %{})
    assert reply == {:ok, 1}
    assert state == %{"foo" => 1}
  end

  test "creates a new counter with initial value 10" do
    {:reply, reply, state} = Promex.Collector.handle_call({:counter, :increment, "foo", [by: 10]}, nil, %{})
    assert reply == {:ok, 10}
    assert state == %{"foo" => 10}
  end

  test "increments an existing counter by 1" do
    {:reply, reply, state} = Promex.Collector.handle_call({:counter, :increment, "foo", [by: 1]}, nil, %{"foo" => 1})
    assert reply == {:ok, 2}
    assert state == %{"foo" => 2}
  end

  test "increments an existing counter by 10" do
    {:reply, reply, state} = Promex.Collector.handle_call({:counter, :increment, "foo", [by: 10]}, nil, %{"foo" => 1})
    assert reply == {:ok, 11}
    assert state == %{"foo" => 11}
  end

end
