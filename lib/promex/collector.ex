defmodule Promex.Collector do
  use GenServer

  @initial_state %{}

  def start_link, do: GenServer.start_link(__MODULE__, :ok, name: __MODULE__)

  def init(:ok), do: {:ok, @initial_state}

  def metrics, do: GenServer.call(__MODULE__, :get)

  #
  # GenServer callbacks
  #

  def handle_call(:get, _from, state), do: {:reply, state, state}

  def handle_cast({:counter, :increment, name, [by: by]}, state) do
    {
      :noreply,
      Map.update(state, name, by, fn(current) -> current + by end)
    }
  end

  def handle_cast({:gauge, :set, name, value}, state) do
    {
      :noreply,
      Map.update(state, name, value, fn(current) -> value end)
    }
  end

end
