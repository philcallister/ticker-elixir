use Mix.Config

config :ticker,
  processor: Ticker.Quote.Processor.HTTPoison
