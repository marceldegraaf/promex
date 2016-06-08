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

  defp parse(metrics),                  do: parse(metrics, "")
  defp parse([metric | list], result),  do: parse(list, parsed(metric) <> result)
  defp parse([], result),               do: result

  defp parsed(metric = %{name: _name, value: _value, doc: _doc}) do
    [type(metric),
     help(metric),
     value(metric)]
    |> Enum.join("\n")
  end

  defp type(metric), do: "TYPE #{metric.name} #{Promex.Metric.type(metric)}"

  defp help(%{doc: nil}),             do: ""
  defp help(%{name: name, doc: doc}), do: "HELP #{name} #{doc}"

  defp value(%{name: name, value: value, labels: labels}) do
    "#{name}" <> labels(labels) <> " " <> "#{inspect value}\n"
  end

  # Transforms a map of labels to the curly enclosed, comma separated
  # `key="value"` format that Prometheus expects, e.g.
  #
  #   %{foo: "bar", baz: "bax"}
  #
  # is transformed to:
  #
  #   {foo="bar",baz="baz"}
  #
  defp labels(labels) when labels == %{}, do: ""
  defp labels(labels) do
    pairs = labels
    |> Enum.map(fn{k, v} -> "#{k}=#{inspect v}" end)
    |> Enum.join(",")

    "{#{pairs}}"
  end

end
