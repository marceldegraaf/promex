defmodule Promex.Gauge do
  @moduledoc """
  Gauge keeps metrics that can go up and down.
  """

  use Promex.Metric
  use Timex

  @doc """
  Set the gauge identified by `name` to the default value of 1.
  """
  def set(name), do: set(name, [to: 1])

  @doc """
  Set the gauge identified by `name` to the value `value` without labels.
  """
  def set(name, [to: value]), do: set(name, [to: value, labels: %{}])

  @doc """
  Set the gauge identified by `name` to the value `value` with labels `labels`.
  """
  def set(registry \\ :default, name, [to: value, labels: labels]) do
    GenServer.call(Promex.Registry.name(registry), {:gauge, :set, name, [to: value, labels: labels]})
  end

  @doc """
  Set the gauge to the current time (in seconds since Unix epoch) with no labels.
  """
  def set_to_current_time(name), do: set(name, to: unix_time)

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
  Increment the gauge identified by `name` by a specific value with no labels.
  """
  def increment(name, [by: value]), do: increment(name, [by: value, labels: %{}])

  @doc """
  Increment the gauge identified by `name` by a specific value with labels `labels`.
  """
  def increment(registry \\ :default, name, [by: value, labels: labels]) do
    GenServer.call(Promex.Registry.name(registry), {:gauge, :increment, name, by: value, labels: labels})
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
  value of -1 with no labels.
  """
  def decrement(name), do: decrement(name, by: 1, labels: %{})

  @doc """
  Decrement the gauge identified by `name` by `value`, or initialize it with a
  value of -`value` with no labels.
  """
  def decrement(name, [by: value]), do: decrement(name, by: value, labels: %{})

  @doc """
  Decrement the gauge identified by `name` by a specific value.
  """
  def decrement(registry \\ :default, name, [by: value, labels: labels]) do
    GenServer.call(Promex.Registry.name(registry), {:gauge, :decrement, name, by: value, labels: labels})
  end

  defp unix_time, do: Timex.Time.now |> Timex.to_unix
end
