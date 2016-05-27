defmodule Promex.Registry.Supervisor do
  use Supervisor

  def start_link, do: Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)

  def init(:ok) do
    children = [
      worker(Promex.Registry, []),
    ]

    supervise(children, strategy: :simple_one_for_one)
  end

  def create(name) do
    Supervisor.start_child(__MODULE__, [name])
  end
end
