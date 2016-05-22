defmodule Promex do
  @moduledoc """
  Supervisor application that runs the Collector and Exporter.
  """

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Promex.Collector, []),
      worker(Promex.Exporter, [], name: Promex.Exporter),
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: __MODULE__)
  end
end
