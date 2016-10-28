defmodule Ticker.Mixfile do
  use Mix.Project

  def project do
    [app: :ticker,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: [test: "test --no-start"],
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [mod: {Ticker, []},
     applications: [:logger, :gproc, :httpoison],
     included_applications: [:distillery, :conform, :poison]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  def deps do
    [
      {:gproc, "~> 0.5.0"},
      {:poison, "~> 2.0"},
      {:httpoison, "~> 0.9.0"},
      {:distillery, "~> 0.10"},
      {:conform, "~> 2.1", override: true}
    ]
  end

end
