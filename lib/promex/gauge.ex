defmodule Promex.Gauge do
  @moduledoc """
  Gauge keeps metrics that can go up and down. A gauge can be incremented and
  decremented, and can be reset to `0`.
  """

  @doc """
  Set a gauge's value.

      iex> Promex.Gauge.set("test_gauge_1")
      {:ok, 1}

      iex> Promex.Gauge.set("test_gauge_1", 10)
      {:ok, 10}

  """
  def set(name), do: set(name, 1)
  def set(name, value) do
    GenServer.call(Promex.Collector, {:gauge, :set, name, value})
  end

  @doc """
  Function alias for `increment`

      iex> Promex.Gauge.inc("test_gauge_2")
      {:ok, 1}
      iex> Promex.Gauge.inc("test_gauge_2", by: 3)
      {:ok, 4}

  """
  defdelegate inc(name), to: __MODULE__, as: :increment
  defdelegate inc(name, opts), to: __MODULE__, as: :increment

  @doc """
  Increment the gauge identified by `name`.

  By default, this will set the gauge value to `1`.
  To set a different initial value, use the `by` option.

    iex> Promex.Gauge.increment("test_gauge_3")
    {:ok, 1}
    iex> Promex.Gauge.increment("test_gauge_3", by: 5)
    {:ok, 6}

  """
  def increment(name), do: increment(name, by: 1)
  def increment(name, [by: value]) do
    GenServer.call(Promex.Collector, {:gauge, :increment, name, by: value})
  end

  @doc """
  Function alias for `decrement`

      iex> Promex.Gauge.dec("test_gauge_4")
      {:ok, -1}
      iex> Promex.Gauge.dec("test_gauge_4", by: 3)
      {:ok, -4}

  """
  defdelegate dec(name), to: __MODULE__, as: :decrement
  defdelegate dec(name, opts), to: __MODULE__, as: :decrement

  @doc """
  Decrement the gauge identified by `name`.

  By default, this will set the gauge value to `-1`.
  To set a different initial value, use the `by` option.

    iex> Promex.Gauge.decrement("test_gauge_5")
    {:ok, -1}
    iex> Promex.Gauge.decrement("test_gauge_5", by: 5)
    {:ok, -6}

  """
  def decrement(name), do: decrement(name, by: 1)
  def decrement(name, [by: value]) do
    GenServer.call(Promex.Collector, {:gauge, :decrement, name, by: value})
  end
end
