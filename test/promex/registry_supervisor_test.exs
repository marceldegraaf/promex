defmodule Promex.Registry.SupervisorTest do
  use ExUnit.Case

  test "creates a new registry" do
    {state, _pid} = Promex.Registry.Supervisor.create(:test)
    assert state == :ok
  end
end
