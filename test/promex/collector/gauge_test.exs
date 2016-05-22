defmodule Promex.Collector.GaugeTest do
  use ExUnit.Case, async: true

  test "creates a new gauge with initial value 1" do
    {:reply, reply, state} = Promex.Collector.handle_call({:gauge, :set, "foo", 1}, nil, %{})
    assert reply == {:ok, 1}
    assert state == %{"foo" => 1}
  end

  test "creates a new gauge with initial value 10" do
    {:reply, reply, state} = Promex.Collector.handle_call({:gauge, :set, "foo", 10}, nil, %{})
    assert reply == {:ok, 10}
    assert state == %{"foo" => 10}
  end

  test "updates an existing gauge" do
    {:reply, reply, state} = Promex.Collector.handle_call({:gauge, :set, "foo", 10}, nil, %{})
    assert reply == {:ok, 10}
    assert state == %{"foo" => 10}

    {:reply, reply, state} = Promex.Collector.handle_call({:gauge, :set, "foo", 5}, nil, %{"foo" => 10})
    assert reply == {:ok, 5}
    assert state == %{"foo" => 5}
  end

end
