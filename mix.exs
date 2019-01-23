defmodule Ticker.Mixfile do
  use Mix.Project

  def project do
    [app: :ticker,
     version: "0.1.0",
     elixir: "~> 1.8",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: [test: "test --no-start"],
     deps: deps(),
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: [coveralls: :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test]]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [mod: {Ticker, []},
     applications: [:logger, :timex, :httpoison],
     included_applications: [:poison]]
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
      {:timex, "~> 3.4"},
      {:poison, "~> 4.0"},
      {:httpoison, "~> 1.5"},
      {:excoveralls, "~> 0.10", only: :test},
      {:mock, "~> 0.3.0", only: :test}
    ]
  end

end
