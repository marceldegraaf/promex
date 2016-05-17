defmodule Promex do
  use Application

  def start(_type, _args) do
    Promex.Supervisor.start_link
  end
end
