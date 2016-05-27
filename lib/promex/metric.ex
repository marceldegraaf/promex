defmodule Promex.Metric do
  defmacro __using__(_opts) do
    quote do
      defstruct name: nil, doc: nil, value: 0
    end
  end

  def type(metric) when is_map(metric), do: type(metric.__struct__)
  def type(Promex.Counter), do: "counter"
  def type(Promex.Gauge), do: "gauge"
end
