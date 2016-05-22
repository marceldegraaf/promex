defmodule Promex.Collector do
  @moduledoc """
  The Collector is where Promex keeps metrics state.
  """

  use GenServer

  @initial_state %{}

  def start_link, do: GenServer.start_link(__MODULE__, :ok, name: __MODULE__)

  def init(:ok), do: {:ok, @initial_state}

  @doc "Returns all metrics collected up to this point"
  def metrics, do: GenServer.call(__MODULE__, :get)

  #
  # GenServer callbacks
  #

  def handle_call(:get, _from, state), do: {:reply, state, state}

  def handle_call({:counter, :increment, name, [by: by]}, _from, state) do
    state = Map.update(state, name, by, fn(current) -> current + by end)
    {:reply, Map.fetch(state, name), state}
  end

  def handle_call({:gauge, :set, name, value}, _from, state) do
    state = Map.update(state, name, value, fn(_) -> value end)
    {:reply, Map.fetch(state, name), state}
  end

end
