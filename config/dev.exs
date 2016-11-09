use Mix.Config

config :ticker,
  frequency: 5_000,
  processor: Ticker.Quote.Processor.Simulate,
  notify_module: Ticker.Periodic.Notify,
  notify_fn: :on
