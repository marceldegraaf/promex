#defmodule Promex.Exporter.Handler do
#  def init({:tcp, :http}, request, options) do
#    headers = [{"Content-Type", "text/plain"}]
#    body = Promex.Exporter.metrics
#
#    {:ok, resp} = :cowboy_req.reply(200, headers, body, request)
#    {:ok, resp, options}
#  end
#
#  def handle(request, state) do
#    {:ok, request, state}
#  end
#
#  def terminate(_reason, _request, _state) do
#    :ok
#  end
#end
