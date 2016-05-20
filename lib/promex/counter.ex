defmodule Promex.Counter do
  def increment(name), do: increment(name, by: 1)
  def increment(name, [by: by]) do
    GenServer.cast(Promex.Collector, {:counter, :increment, name, by: by})
  end
end
