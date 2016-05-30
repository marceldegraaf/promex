defmodule Promex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :promex,
      version: "0.0.1",
      elixir: "~> 1.2",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps,
      test_coverage: [tool: ExCoveralls],
    ]
  end

  def application do
    [
      applications: [:logger, :cowboy, :plug, :gproc, :timex],
      mod: {Promex, []}
    ]
  end

  defp deps do
    [
      {:cowboy, "~> 1.0"},
      {:plug, "~> 1.1"},
      {:gproc, "~> 0.5"},
      {:timex, "~> 2.1.0"},

      # Testing/development/docs dependencies
      {:credo, "~> 0.3.10", only: [:dev, :test]},
      {:dialyxir, "~> 0.3.3", only: [:dev, :test]},
      {:mock, "~> 0.1.1", only: :test},
      {:excoveralls, "~> 0.5", only: :test},
      {:inch_ex, "~> 0.5.0", only: :docs},
      {:earmark, "~> 0.1.0", only: :dev},
      {:ex_doc, "~> 0.11.0", only: :dev},
      {:mix_test_watch, "~> 0.2", only: :dev},
    ]
  end
end
