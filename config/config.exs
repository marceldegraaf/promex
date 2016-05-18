use Mix.Config

config :promex,
  port: 9000,
  endpoint: "/metrics"

import_config "#{Mix.env}.exs"
