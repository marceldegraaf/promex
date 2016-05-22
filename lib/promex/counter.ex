defmodule Promex.Counter do
  @moduledoc """
  Counter keeps simple, monotonous counter metrics. Counters can only ever go up.
  """

  defdelegate inc(name), to: __MODULE__, as: :increment
  defdelegate inc(name, opts), to: __MODULE__, as: :increment

  @doc """
  Increment the counter identified by `name` by 1, or initialize it with a
  value of 1.

      iex> Promex.Counter.increment("test_counter_1")
      {:ok, 1}
      iex> Promex.Counter.increment("test_counter_1")
      {:ok, 2}

  """
  def increment(name), do: increment(name, by: 1)

  @doc """
  Increment the counter identified by `name` by a specific value.

      iex> Promex.Counter.increment("test_counter_2")
      {:ok, 1}
      iex> Promex.Counter.increment("test_counter_2", by: 5)
      {:ok, 6}

  """
  def increment(name, [by: value]) do
    GenServer.call(Promex.Collector, {:counter, :increment, name, by: value})
  end
end
