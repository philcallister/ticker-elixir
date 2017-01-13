use Mix.Config

config :ticker,
  processor: Ticker.Quote.Processor.Static,
  url: "http://finance.google.com/finance/info?client=ig&q=NASDAQ%3A",
  symbols: ["TSLA", "GOOG"]