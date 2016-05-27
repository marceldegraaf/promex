defmodule Promex.Metric do
  defmacro __using__(_opts) do
    quote do
      defstruct name: nil, doc: nil, value: 0
    end
  end
end
