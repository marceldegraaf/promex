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

  @doc "Returns the samples from all Collectors in this Registry"
  def collect(registry \\ :default), do: GenServer.call(name(registry), :collect)

  @doc "Registers a Collector with a Registry"
  def register(registry \\ :default, metric), do: GenServer.cast(name(registry), {:register, metric})

  #
  # GenServer callbacks
  #

  def handle_call(:collect, _from, state) do
    reply = state
    |> Map.values
    |> Enum.reduce(%{}, &reduce_metrics/2)

    {:reply, reply, state}
  end

  def handle_cast({:register, metric}, state) do
    state = state
    |> Map.put_new(metric.name, metric)

    {:noreply, state}
  end

  defp name(name), do: String.to_atom("Elixir.Promex.Registry (#{name})")

  defp reduce_metrics(metric, acc), do: Map.put_new(acc, metric.name, metric.value)
end
