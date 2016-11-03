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

    frequency = Application.get_env(:ticker, :frequency, 60_000)

    children = [
      supervisor(Ticker.Symbol.Supervisor, []),
      worker(Ticker.Periodically, [fn -> Ticker.Periodic.Timer.on end, frequency])
    ]

    opts = [strategy: :one_for_one, name: Ticker.Supervisor]
    Supervisor.start_link(children, opts)
  end

end