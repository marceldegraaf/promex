defmodule Promex.Counter do
  @moduledoc """
  Counter keeps simple, monotonous counter metrics. Counters can only ever go up,
  so there are no functions to decrement a counter metric. It is, however, possible
  to reset a counter to `0`.
  """

  @doc """
  Function alias for `increment`

      iex> Promex.Counter.inc("test_counter_1")
      {:ok, 1}
      iex> Promex.Counter.inc("test_counter_1", by: 3)
      {:ok, 4}

  """
  defdelegate inc(name), to: __MODULE__, as: :increment
  defdelegate inc(name, opts), to: __MODULE__, as: :increment

  @doc """
  Increments the counter identified by `name`.

  By default, this will set the counter value to `1`.
  To set a different initial value, use the `by` option.

    iex> Promex.Counter.increment("test_counter_2")
    {:ok, 1}
    iex> Promex.Counter.increment("test_counter_2", by: 5)
    {:ok, 6}

  """
  def increment(name), do: increment(name, by: 1)
  def increment(name, [by: value]) do
    GenServer.call(Promex.Collector, {:counter, :increment, name, by: value})
  end
end
