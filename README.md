# Promex

[![Build Status](https://travis-ci.org/marceldegraaf/promex.svg?branch=master)](https://travis-ci.org/marceldegraaf/promex)
[![Coverage Status](https://coveralls.io/repos/github/marceldegraaf/promex/badge.svg?branch=master)](https://coveralls.io/github/marceldegraaf/promex?branch=master)
[![Deps Status](https://beta.hexfaktor.org/badge/all/github/marceldegraaf/promex.svg)](https://beta.hexfaktor.org/github/marceldegraaf/promex)
[![Docs](http://inch-ci.org/github/marceldegraaf/promex.svg)](http://inch-ci.org/github/marceldegraaf/promex)

Promex is a Prometheus client library for Elixir. It can track arbitrary
application metrics through a simple API, and exposes an HTTP endpoint to
Prometheus for scraping.

**Note**: this package is very much work in progress. Nothing is stable yet. Do
not use this in production.

## To do before 1.0 release

Promex adheres to [Prometheus' client library guide](https://prometheus.io/docs/instrumenting/writing_clientlibs/)
as much as possible. These things are still required to make that happen, in no
particular order:

- [ ] Implement standard/runtime collectors, as [documented here](https://docs.google.com/document/d/1Q0MXWdwp1mdXCzNRak6bW5LLVylVRXhdi7_21Sg15xQ/edit).
- [ ] Add support for pushing metrics to a PushGateway, e.g. for short-running
    batch processes.
    exporter
- [ ] Implement `summary` and/or `histogram` metric type
- [x] Make it possible to add labels to a metric, and expose them in the
- [x] Refactor code so metrics can be registered to one or more registries which
    each have their own exporter.
- [x] Let counters and gauges start at `0`
- [x] Implement the advised function names to set/change metric values of
    different types.
- [x] Add the option to supply HELP text for a metric, or generate a default
    automatically.
- [x] Add gzip compression to exporter endpoint.

## Installation

  1. Add promex to your list of dependencies in `mix.exs`:

        def deps do
          [{:promex, "~> 0.0.1"}]
        end

  2. Ensure promex is started before your application:

        def application do
          [applications: [:promex]]
        end

## Usage

Promex exposes a simple API to track arbitrary metrics in one or more
registries. By default the `:default` registry is created for you, and
registering metrics without passing a registry name will register the metric in
this default registry.

To create a new registry, use `Promex.Registry.Supervisor.create/1`:

    iex> Promex.Registry.Supervisor.create :web
    {:ok, _pid}

Use the registry name (in this case `:web`) to register metrics with the
registry. Make sure to register a metric before working with it, as the registry
keeps metric state. To register a metric in the default registry,
use `Promex.Registry.register/1`:

    iex> Promex.Registry.register %Promex.Counter{name: "foo"}
    :ok

To register a metric in a non-default registry, use
`Promex.Registry.register/2`:

    iex> Promex.Registry.register :web, %Promex.Counter{name: "foo"}
    :ok

To collect all metrics from the default registry, use `Promex.Registry.collect/0`:

    iex> Promex.Registry.collect
    %{"foo" => 0, ...}

To collect all metrics from a non-default registry, use
`Promex.Registry.collect/1`:

    iex> Promex.Registry.collect :web
    %{"foo" => 0, ...}

## Types

Promex currently supports couters and gauges, and will support histograms and/or
summaries in the future.

### Registering

As shown above, use `Promex.Registry.register/1` or `Promex.Registry.register/2`
to register a metric. Pass the metric struct as argument, e.g.:

    counter = %Promex.Counter{name: "foo", doc: "the help text"}
    gauge   = %Promex.Gauge{name: "bar", doc: "the help text"}

    Promex.Registry.register(counter)
    Promex.Registry.register(:web, gauge)

### Counter

Counters can only ever go up. To increase a couter, use `increment` or `inc`:

    Promex.Counter.increment("foo")
    Promex.Counter.inc("bar")

By default this will increment your counter by 1. If the counter didn't exist,
it will be created with an initial value of 1 and registered to the `:default`
registry. To increment with another amount, use:

    Promex.Counter.increment("foo", by: 10)
    Promex.Counter.inc("bar", by: 3)

### Gauge

Gauges can go up and down. To set the value of a gauge, use `set`:

    Promex.Gauge.set("foo")

By default this will set the gauge to 1. If the gauge didn't exist it will be created
with an initial value of 1 and be registered to the `:default` registry.
To set a specific value, use:

    Promex.Gauge.set("foo", to: 10)
    Promex.Gauge.set("bar", to: -5)

Gauges can also be increased:

    Promex.Gauge.increase("foo")
    Promex.Gauge.inc("bar")

    Promex.Gauge.increase("foo", by: 5)
    Promex.Gauge.inc("bar", by: 10)

And decreased:

    Promex.Gauge.decrease("foo")
    Promex.Gauge.dec("bar")

    Promex.Gauge.decrease("foo", by: 5)
    Promex.Gauge.dec("bar", by: 10)

## Configuration

Promex can be configured in `config.exs`. These are the default settings:

    config :promex,
      port: 9000
      endpoint: "/metrics"
