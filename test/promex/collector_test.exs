defmodule Promex.CollectorTest do
  use ExUnit.Case

  test "initializes with an empty state" do
    assert Promex.Collector.metrics == %{}
  end
end
