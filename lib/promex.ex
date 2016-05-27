defmodule Promex do
  @moduledoc """
  Supervisor application that runs the Collector and Exporter.
  """

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Promex.Exporter, []),
      worker(Promex.Registry.Supervisor, []),
    ]

    {:ok, pid} = Supervisor.start_link(children, strategy: :one_for_one, name: __MODULE__)

    # Start default registry
    {:ok, _pid} = Promex.Registry.Supervisor.create(:default)

    {:ok, pid}
  end
end
