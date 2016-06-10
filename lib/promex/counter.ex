defmodule Promex.Counter do
  @moduledoc """
  Counter keeps simple, monotonous counter metrics. Counters can only ever go up.
  """

  use Promex.Metric

  @doc """
  Alias for `increment/1`
  """
  defdelegate inc(name), to: __MODULE__, as: :increment

  @doc """
  Alias for `increment/2`
  """
  defdelegate inc(name, opts), to: __MODULE__, as: :increment

  @doc """
  Increment the counter identified by `name` by 1, or initialize it with a
  value of 1.
  """
  def increment(name), do: increment(name, by: 1, labels: %{})

  @doc """
  Increment the counter identified by `name` by `by`, or initialize it with a
  value of `by`.
  """
  def increment(name, [by: by]), do: increment(name, by: by, labels: %{})

  @doc """
  Increment the counter identified by `name` by 1, or initialize it with a
  value of 1, while setting `labels` as labels.
  """
  def increment(name, [labels: labels]), do: increment(name, by: 1, labels: labels)

  @doc """
  Increment the counter identified by `name` by a specific value.
  """
  def increment(registry \\ :default, name, [by: value, labels: labels]) do
    GenServer.call(Promex.Registry.name(registry), {:counter, :increment, name, by: value, labels: labels})
  end
end
