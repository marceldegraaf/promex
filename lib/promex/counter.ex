defmodule Promex.Counter do
  alias Promex.Collector

  def increment(name, args \\ []) do
    Collector.counter_increment(name, args)
  end
end
