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
      supervisor(Ticker.SymbolSupervisor, [])
    ]

    opts = [strategy: :one_for_one, name: Ticker.Supervisor]
    ret = Supervisor.start_link(children, opts)
    add_config_symbols
    ret
  end

  defp add_config_symbols do
    symbols = Application.get_env(:ticker, :symbols)
    Enum.each(symbols, fn(s) -> Ticker.SymbolSupervisor.add_symbol(s) end)
  end


end