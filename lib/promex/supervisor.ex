defmodule Promex.Supervisor do
  import Supervisor.Spec

  def start_link do
    children = [
      worker(Promex.Collector, []),
      worker(Promex.Exporter, [], function: :start),
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: __MODULE__)
  end
end
