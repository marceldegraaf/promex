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
  # Registry callbacks
  #

  def handle_cast({:register, metric}, state) do
    {:noreply, Map.put(state, metric.name, metric)}
  end

  def handle_call(:collect, _from, state) do
    {:reply, Map.values(state), state}
  end

  #
  # Counter callbacks
  #

  def handle_call({:counter, :increment, _name, [by: value, labels: _labels]}, _from, state) when not is_number(value) do
    {:reply, {:error, "increment must be a number"}, state}
  end

  def handle_call({:counter, :increment, _name, [by: value, labels: _labels]}, _from, state) when value < 0 do
    {:reply, {:error, "increment must be a non-negative number"}, state}
  end

  def handle_call({:counter, :increment, name, [by: value, labels: labels]}, _from, state) when value > 0 do
    with \
      true         <- Map.has_key?(state, name),
      {:ok, state} <- increment_counter(name, labels, value, state)
    do
      {:reply, Map.fetch(state, name), state}
    else
      false -> {:reply, {:error, "metric '#{name}' is not registered"}, state}
    end
  end

  #
  # Gauge callbacks
  #

  def handle_call({:gauge, :set, _name, [to: value, labels: _labels]}, _from, state) when not is_number(value) do
    {:reply, {:error, "value must be a number"}, state}
  end

  def handle_call({:gauge, :increment, _name, [by: value, labels: _labels]}, _from, state) when not is_number(value) do
    {:reply, {:error, "increment must be a number"}, state}
  end

  def handle_call({:gauge, :set, name, [to: value, labels: labels]}, _from, state) do
    with \
      true         <- Map.has_key?(state, name),
      {:ok, state} <- set_gauge(name, labels, value, state)
    do
      {:reply, Map.fetch(state, name), state}
    else
      false -> {:reply, {:error, "metric '#{name}' is not registered"}, state}
    end
  end

  def handle_call({:gauge, :increment, name, [by: value, labels: labels]}, _from, state) do
    with \
      true         <- Map.has_key?(state, name),
      {:ok, state} <- increment_gauge(name, labels, value, state)
    do
      {:reply, Map.fetch(state, name), state}
    else
      false -> {:reply, {:error, "metric '#{name}' is not registered"}, state}
    end
  end

  def handle_call({:gauge, :decrement, _name, [by: value, labels: _labels]}, _from, state) when not is_number(value) do
    {:reply, {:error, "decrement must be a number"}, state}
  end

  def handle_call({:gauge, :decrement, name, [by: value, labels: labels]}, _from, state) do
    with \
      true         <- Map.has_key?(state, name),
      {:ok, state} <- decrement_gauge(name, labels, value, state)
    do
      {:reply, Map.fetch(state, name), state}
    else
      false -> {:reply, {:error, "metric '#{name}' is not registered"}, state}
    end
  end

  @doc "Generates a name for this Registry process"
  def name(name), do: String.to_atom("Elixir.Promex.Registry (#{name})")

  defp increment_counter(name, labels, value, state) do
    state = Kernel.update_in(
      state[name].values,
      fn(x) ->
        Map.update(x, labels, value, &(&1 + value))
      end
    )

    {:ok, state}
  end

  defp set_gauge(name, labels, value, state) do
    state = Kernel.update_in(
      state[name].values,
      fn(x) ->
        Map.update(x, labels, value, fn(_) -> value end)
      end
    )

    {:ok, state}
  end

  defp increment_gauge(name, labels, value, state) do
    state = Kernel.update_in(
      state[name].values,
      fn(x) ->
        Map.update(x, labels, value, &(&1 + value))
      end
    )

    {:ok, state}
  end

  defp decrement_gauge(name, labels, value, state) do
    state = Kernel.update_in(
      state[name].values,
      fn(x) ->
        Map.update(x, labels, -value, &(&1 - value))
      end
    )

    {:ok, state}
  end
end
