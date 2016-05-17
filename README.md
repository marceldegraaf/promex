# Promex

Promex is a Prometheus client library for Elixir. It can track arbitrary
application metrics through a simple API, and exposes an HTTP endpoint to
Prometheus for scraping.

**Note**: this package is very much work in progress. Nothing is stable yet. Do
not use this in production.

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

Promex exposes a simple API to track arbitrary metrics. Usage instructions are
broken down by metric type below.

### Counter

To increment a counter, use:

    Promex.Counter.incremen("foo")

By default this will increment your counter by 1. If the counter didn't exist,
it will be created with an initial value of 1. To increment with another amount,
use:

    Promex.Counter.increment("foo", by: 10)
