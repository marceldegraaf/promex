defmodule Promex.RegistryTest do
  use ExUnit.Case

  setup do
    metric = %Promex.Counter{name: "foo", doc: "this is the help text"}
    {:ok, metric: metric}
  end

  test "collects metrics", %{metric: metric} do
    {:reply, reply, state} = Promex.Registry.handle_call(:collect, nil, %{"foo" => metric})
    assert reply == %{"foo" => metric.value}
    assert state == %{"foo" => metric}
  end

  test "registers a new metric", %{metric: metric} do
    {:noreply, state} = Promex.Registry.handle_cast({:register, metric}, %{})
    assert state == %{"foo" => metric}
  end

end
