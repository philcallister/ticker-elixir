use Mix.Config

config :ticker,
  frequency: 5_000,
  processor: Ticker.Quote.Processor.Simulate,
  historical: true,
  quote_notify: [notify_module: Ticker.Notify.Log, notify_fn: :info],
  frame_notify: [notify_module: Ticker.Notify.Log, notify_fn: :info]
