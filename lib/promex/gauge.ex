defmodule Promex.Gauge do
  use Promex.Metric

  @moduledoc """
  Gauge keeps metrics that can go up and down.
  """

  @doc """
  Set the gauge identified by `name` to the default value of 1.

      iex> Promex.Gauge.set("test_gauge_1")
      {:ok, 1}

  """
  def set(name), do: set(name, 1)

  @doc """
  Set the gauge identified by `name` to the value `value`.

      iex> Promex.Gauge.set("test_gauge_1", 10)
      {:ok, 10}

  """
  def set(name, value) do
    GenServer.call(Promex.Collector, {:gauge, :set, name, value})
  end

  defdelegate inc(name), to: __MODULE__, as: :increment
  defdelegate inc(name, opts), to: __MODULE__, as: :increment

  @doc """
  Increment the gauge identified by `name` by 1, or initialize it with a
  value of 1.

      iex> Promex.Gauge.increment("test_gauge_2")
      {:ok, 1}
      iex> Promex.Gauge.increment("test_gauge_2")
      {:ok, 2}

  """
  def increment(name), do: increment(name, by: 1)

  @doc """
  Increment the gauge identified by `name` by a specific value.

      iex> Promex.Gauge.set("test_gauge_3")
      {:ok, 1}
      iex> Promex.Gauge.increment("test_gauge_3", by: 5)
      {:ok, 6}

  """
  def increment(name, [by: value]) do
    GenServer.call(Promex.Collector, {:gauge, :increment, name, by: value})
  end

  defdelegate dec(name), to: __MODULE__, as: :decrement
  defdelegate dec(name, opts), to: __MODULE__, as: :decrement

  @doc """
  Decrement the gauge identified by `name` by 1, or initialize it with a
  value of -1.

      iex> Promex.Gauge.decrement("test_gauge_4")
      {:ok, -1}
      iex> Promex.Gauge.decrement("test_gauge_4")
      {:ok, -2}

  """
  def decrement(name), do: decrement(name, by: 1)

  @doc """
  Decrement the gauge identified by `name` by a specific value.

  By default, this will set the gauge value to `-1`.
  To set a different initial value, use the `by` option.

      iex> Promex.Gauge.decrement("test_gauge_5", by: 5)
      {:ok, -5}
      iex> Promex.Gauge.decrement("test_gauge_5", by: 5)
      {:ok, -10}

  """
  def decrement(name, [by: value]) do
    GenServer.call(Promex.Collector, {:gauge, :decrement, name, by: value})
  end
end
