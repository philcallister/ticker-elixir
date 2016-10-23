require Logger

defmodule Ticker do
  @moduledoc """
  Ticker OTP Application
  """
  use Application

  @doc false
  def start(_type, _args) do
    import Supervisor.Spec

    Logger.info("Starting Ticker OTP Application")

    children = [
      supervisor(Ticker.Symbol.Supervisor, []),
      worker(Ticker.Quote.Processor, []),
      worker(Ticker.Periodically, [fn -> Ticker.Quote.Processor.quotes end, 60_000])
    ]

    opts = [strategy: :one_for_one, name: Ticker.Supervisor]
    Supervisor.start_link(children, opts)
  end

end