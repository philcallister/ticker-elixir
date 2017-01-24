require Logger

defmodule Ticker.Security.Supervisor do
  use Supervisor

  def start_link(empty) when empty do
    Logger.info("Starting Security Supervisor (NO Symbols)...")
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def start_link do
    Logger.info("Starting Security Supervisor...")
    {:ok, pid} = Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
    add_config_securites()
    {:ok, pid}
  end

  def add_security(symbol) do
    Supervisor.start_child(__MODULE__, [symbol])
  end

  def add_securites(symbols) do
    Enum.each(symbols, fn(s) -> add_security(s) end)
  end

  defp add_config_securites do
    symbols = Application.get_env(:ticker, :symbols)
    add_securites(symbols)
  end


  ## Server callbacks

  def init(:ok) do
    children = [
      supervisor(Ticker.Symbol.Supervisor, [], restart: :transient)
    ]
    supervise(children, strategy: :simple_one_for_one)
  end

end
