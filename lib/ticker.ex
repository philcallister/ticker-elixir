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
      supervisor(Ticker.SymbolSupervisor, []),
      worker(Ticker.QuoteProcessor, []),
      worker(Ticker.Periodically, [])
    ]

    opts = [strategy: :one_for_one, name: Ticker.Supervisor]
    Supervisor.start_link(children, opts)
  end

end