defmodule Promex.Gauge do
  def set(name), do: set(name, 1)
  def set(name, value) do
    GenServer.cast(Promex.Collector, {:gauge, :set, name, value})
  end
end
