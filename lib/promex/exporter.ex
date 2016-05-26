defmodule Promex.Exporter do
  @moduledoc """
  Exporter exposes an HTTP endpoint for Prometheus to ingest metrics.
  """

  use Plug.Router
  require Logger

  plug :match
  plug :dispatch

  def init(opts), do: opts

  @doc "Starts the Exporter process."
  def start_link do
    Plug.Adapters.Cowboy.http(
      Promex.Exporter,
      [],
      [port: Application.get_env(:promex, :port),
       compress: true]
    )
  end

  get Application.get_env(:promex, :endpoint) do
    conn
    |> send_resp(200, Promex.Registry.collect(:default) |> parse)
    |> halt
  end

  match _ do
    conn
    |> send_resp(404, "Not Found")
    |> halt
  end

  defp parse(metrics = %{}) do
    IO.inspect metrics

    metrics
    |> Enum.map(&parse/1)
  end

  defp parse({name, value}) do
    name <> " " <> Kernel.inspect(value) <> "\n"
  end
end
