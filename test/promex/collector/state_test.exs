defmodule Promex.Collector.StateTest do
  use ExUnit.Case, async: true

  test "initializes with an empty state" do
    assert Promex.Collector.metrics == %{}
  end
end
