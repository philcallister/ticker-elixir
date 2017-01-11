use Mix.Config

config :ticker,
  processor: Ticker.Quote.Processor.Static,
  symbols: ["TSLA", "GOOG"]