defmodule Promex.Registry do
  @moduledoc """
  Registry is where Collectors are registered. Registry exposes all metrics
  from its Collectors to the Exporter.
  """

  use GenServer

  @doc "Starts a new Registry"
  def start_link(name) do
    GenServer.start_link(__MODULE__, :ok, [name: name(name)])
  end

  def init(:ok), do: {:ok, Map.new}

  @doc "Returns the samples from all metrics in this Registry"
  def collect(registry \\ :default), do: GenServer.call(name(registry), :collect)

  @doc "Registers a metric with a Registry"
  def register(registry \\ :default, metric), do: GenServer.cast(name(registry), {:register, metric})

  #
  # GenServer callbacks
  #

  def handle_cast({:register, metric}, state) do
    state = state
    |> Map.put(metric.name, metric)

    {:noreply, state}
  end

  def handle_call(:collect, _from, state) do
    {:reply,
     state |> Map.values,
     state}
  end

  #
  # Counter callbacks
  #

  def handle_call({:counter, :increment, _name, [by: value]}, _from, state) when not is_number(value) do
    {:reply, {:error, "increment must be a number"}, state}
  end

  def handle_call({:counter, :increment, _name, [by: value]}, _from, state) when value < 0 do
    {:reply, {:error, "increment must be a non-negative number"}, state}
  end

  def handle_call({:counter, :increment, name, [by: value]}, _from, state) when value > 0 do
    state = Map.update(
      state,
      name,
      %Promex.Counter{name: name, value: value},
      fn(current) -> %Promex.Counter{current | value: current.value + value} end)

    {:reply, Map.fetch(state, name), state}
  end

  #
  # Gauge callbacks
  #

  def handle_call({:gauge, :set, name, value}, _from, state) do
    state = Map.update(
      state,
      name,
      %Promex.Gauge{name: name, value: value},
      fn(current) -> %Promex.Gauge{current | value: value} end)

    {:reply, Map.fetch(state, name), state}
  end

  def handle_call({:gauge, :increment, name, [by: value]}, _from, state) do
    state = Map.update(
      state,
      name,
      %Promex.Gauge{name: name, value: value},
      fn(current) -> %Promex.Gauge{current | value: current.value + value} end)

    {:reply, Map.fetch(state, name), state}
  end

  def handle_call({:gauge, :decrement, name, [by: value]}, _from, state) do
    state = Map.update(
      state,
      name,
      %Promex.Gauge{name: name, value: -value},
      fn(current) -> %Promex.Gauge{current | value: current.value - value} end)

    {:reply, Map.fetch(state, name), state}
  end

  @doc "Generates a name for this Registry process"
  def name(name), do: String.to_atom("Elixir.Promex.Registry (#{name})")
end
