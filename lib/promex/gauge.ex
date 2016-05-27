defmodule Promex.Gauge do
  @moduledoc """
  Gauge keeps metrics that can go up and down.
  """

  use Promex.Metric

  @doc """
  Set the gauge identified by `name` to the default value of 1.
  """
  def set(name), do: set(name, [to: 1])

  @doc """
  Set the gauge identified by `name` to the value `value`.
  """
  def set(registry \\ :default, name, [to: value]) do
    GenServer.call(Promex.Registry.name(registry), {:gauge, :set, name, value})
  end

  @doc """
  Alias for `increment/1`
  """
  defdelegate inc(name), to: __MODULE__, as: :increment

  @doc """
  Alias for `increment/2`
  """
  defdelegate inc(name, opts), to: __MODULE__, as: :increment

  @doc """
  Increment the gauge identified by `name` by 1, or initialize it with a
  value of 1.
  """
  def increment(name), do: increment(name, by: 1)

  @doc """
  Increment the gauge identified by `name` by a specific value.
  """
  def increment(registry \\ :default, name, [by: value]) do
    GenServer.call(Promex.Registry.name(registry), {:gauge, :increment, name, by: value})
  end

  @doc """
  Alias for `decrement/1`
  """
  defdelegate dec(name), to: __MODULE__, as: :decrement

  @doc """
  Alias for `decrement/2`
  """
  defdelegate dec(name, opts), to: __MODULE__, as: :decrement

  @doc """
  Decrement the gauge identified by `name` by 1, or initialize it with a
  value of -1.
  """
  def decrement(name), do: decrement(name, by: 1)

  @doc """
  Decrement the gauge identified by `name` by a specific value.
  """
  def decrement(registry \\ :default, name, [by: value]) do
    GenServer.call(Promex.Registry.name(registry), {:gauge, :decrement, name, by: value})
  end
end
