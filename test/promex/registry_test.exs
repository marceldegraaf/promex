defmodule Promex.RegistryTest do
  use ExUnit.Case

  setup do
    metric = %Promex.Counter{name: "foo", doc: "this is the help text", value: 0}
    {:ok, metric: metric}
  end

  test "collects metrics", %{metric: metric} do
    {:reply, reply, state} = Promex.Registry.handle_call(:collect, nil, %{"foo" => metric})
    assert reply == [metric]
    assert state == %{"foo" => metric}
  end

  test "registers a new metric", %{metric: metric} do
    {:noreply, state} = Promex.Registry.handle_cast({:register, metric}, %{})
    assert state == %{"foo" => metric}
  end

  test "creates a new counter with initial value 1" do
    {:reply, reply, state} = Promex.Registry.handle_call({:counter, :increment, "foo", [by: 1]}, nil, %{})
    assert reply == {:ok, %Promex.Counter{name: "foo", value: 1}}
    assert state == %{"foo" => %Promex.Counter{name: "foo", value: 1}}
  end

  test "creates a new counter with initial value 10" do
    {:reply, reply, state} = Promex.Registry.handle_call({:counter, :increment, "foo", [by: 10]}, nil, %{})
    assert reply == {:ok, %Promex.Counter{name: "foo", value: 10}}
    assert state == %{"foo" => %Promex.Counter{name: "foo", value: 10}}
  end

  test "increments an existing counter by 1", %{metric: metric} do
    {:reply, reply, state} = Promex.Registry.handle_call({:counter, :increment, "foo", [by: 1]}, nil, %{"foo" => metric})
    assert reply == {:ok, %{metric | value: 1}}
    assert state == %{"foo" => %{metric | value: 1}}
  end

  test "increments an existing counter by 10", %{metric: metric} do
    {:reply, reply, state} = Promex.Registry.handle_call({:counter, :increment, "foo", [by: 10]}, nil, %{"foo" => metric})
    assert reply == {:ok, %{metric | value: 10}}
    assert state == %{"foo" => %{metric | value: 10}}
  end

end
