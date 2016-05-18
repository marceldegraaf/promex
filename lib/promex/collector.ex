defmodule Promex.Collector do
  use GenServer

  @initial_state %{}

  def start_link, do: GenServer.start_link(__MODULE__, :ok, name: __MODULE__)

  def init(:ok), do: {:ok, @initial_state}

  #
  # Public API
  #

  def metrics, do: GenServer.call(__MODULE__, :get)

  def counter_increment(name, []), do: counter_increment(name, by: 1)
  def counter_increment(name, [by: by]) do
    GenServer.cast(__MODULE__, {:counter, :increment, name, by: by})
  end

  #
  # GenServer callbacks
  #

  def handle_call(:get, _from, state), do: {:reply, state, state}

  def handle_cast({:counter, :increment, name, [by: by]}, state) do
    {
      :noreply,
      Map.update(state, name, by, fn(value) -> value + by end)
    }
  end

end
