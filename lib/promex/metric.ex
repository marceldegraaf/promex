defmodule Promex.Metric do
  defmacro __using__(_opts) do
    quote do
      defstruct name: nil, doc: nil, values: %{}
    end
  end

  def type(metric) when is_map(metric), do: type(metric.__struct__)
  def type(Promex.Counter), do: "counter"
  def type(Promex.Gauge), do: "gauge"
  def type(label) do
    raise ArgumentError, message: "#{label} is not a valid metric type"
  end
end
