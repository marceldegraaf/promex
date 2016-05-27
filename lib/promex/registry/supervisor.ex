defmodule Promex.Registry.Supervisor do
  @moduledoc """
  Supervises metric registries.
  """

  use Supervisor

  @doc """
  Start the registry supervisor.
  """
  def start_link, do: Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)

  def init(:ok) do
    children = [
      worker(Promex.Registry, []),
    ]

    supervise(children, strategy: :simple_one_for_one)
  end

  @doc """
  Create a new registry called `name`. Use this same name to reference the
  registry later on, e.g. to register a metric or collect metric values.

      iex> {:ok, pid} = Promex.Registry.Supervisor.create :web
      iex> is_pid(pid)
      true

  """
  def create(name) do
    Supervisor.start_child(__MODULE__, [name])
  end
end
