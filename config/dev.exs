use Mix.Config

config :ticker,
  notify_module: Ticker.Periodic.Notify,
  notify_fn: :on
