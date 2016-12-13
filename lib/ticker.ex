require Logger

defmodule Ticker do
  @moduledoc """
  Ticker OTP Application
  """
  use Application

  @doc false
  def start(_type, _args) do
    import Supervisor.Spec

    Logger.info("Starting Ticker OTP Application...")

    frequency = Application.get_env(:ticker, :frequency, 60_000)

    initial_children = [
      supervisor(Ticker.Security.Supervisor, []),
      worker(Ticker.Periodically, [fn -> Ticker.Periodic.Timer.on end, frequency])
    ]

    # TODO: Would be nice to start this in another place. Really shouldn't have to
    # know the processor at this point.
    processor = Application.get_env(:ticker, :processor)
    children = case processor do
      Ticker.Quote.Processor.Simulate -> [worker(Ticker.Quote.Processor.Simulate, []) | initial_children]
      _ -> initial_children
    end

    opts = [strategy: :one_for_one, name: Ticker.Supervisor]
    Supervisor.start_link(children, opts)
  end

end