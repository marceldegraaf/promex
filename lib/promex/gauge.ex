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
end
