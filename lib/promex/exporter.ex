defmodule Promex.Exporter do
  alias Promex.Collector

  def start do
    routes = [
      {"/", Promex.Exporter.Handler, []}
    ]

    dispatch = :cowboy_router.compile([{:_, routes}])

    {:ok, _pid} = :cowboy.start_http(:http, 100, [port: 8000], [env: [dispatch: dispatch]])
  end

  def metrics do
    Enum.map(Collector.metrics, fn(metric) -> parse(metric) end)
  end

  defp parse(metric) do
    metric = Tuple.to_list(metric)

    "#{List.first(metric)} #{List.last(metric)}\n"
  end
end
