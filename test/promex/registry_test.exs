defmodule Promex.RegistryTest do
  use ExUnit.Case

  setup do
    metric = %Promex.Counter{name: "foo", doc: "this is the help text", values: %{%{} => 0}}
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

  test "can not increment a counter that is not registered" do
    {:reply, reply, state} = Promex.Registry.handle_call({:counter, :increment, "foo", [by: 10, labels: %{}]}, nil, %{})
    assert reply == {:error, "metric 'foo' is not registered"}
    assert state == %{}
  end

  test "can not set a gauge that is not registered" do
    {:reply, reply, state} = Promex.Registry.handle_call({:gauge, :set, "foo", [to: 10, labels: %{}]}, nil, %{})
    assert reply == {:error, "metric 'foo' is not registered"}
    assert state == %{}
  end

  test "can not increment a gauge that is not registered" do
    {:reply, reply, state} = Promex.Registry.handle_call({:gauge, :increment, "foo", [by: 10, labels: %{}]}, nil, %{})
    assert reply == {:error, "metric 'foo' is not registered"}
    assert state == %{}
  end

  test "can not decrement a gauge that is not registered" do
    {:reply, reply, state} = Promex.Registry.handle_call({:gauge, :decrement, "foo", [by: 10, labels: %{}]}, nil, %{})
    assert reply == {:error, "metric 'foo' is not registered"}
    assert state == %{}
  end

  test "increments an existing counter by 1", %{metric: metric} do
    {:reply, reply, state} = Promex.Registry.handle_call({:counter, :increment, "foo", [by: 1, labels: %{}]}, nil, %{"foo" => metric})
    assert reply == {:ok, %{metric | values: %{%{} => 1}}}
    assert state == %{"foo" => %{metric | values: %{%{} => 1}}}
  end

  test "increments an existing counter by 10", %{metric: metric} do
    {:reply, reply, state} = Promex.Registry.handle_call({:counter, :increment, "foo", [by: 10, labels: %{}]}, nil, %{"foo" => metric})
    assert reply == {:ok, %{metric | values: %{%{} => 10}}}
    assert state == %{"foo" => %{metric | values: %{%{} => 10}}}
  end

end
