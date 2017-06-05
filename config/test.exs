use Mix.Config

config :ticker,
  processor: Ticker.Quote.Processor.Static,
  url: "https://api.iextrading.com/1.0/tops?symbols=",
  symbols: ["TSLA", "GOOG"]