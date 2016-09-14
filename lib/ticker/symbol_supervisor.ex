require Logger

defmodule Ticker.SymbolSupervisor do
  use Supervisor

  def start_link do
    Logger.info("Starting Symbol Supervisor...")
    {:ok, pid} = Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
    Ticker.SymbolConfig.add_config_symbols
    {:ok, pid}
  end

  def add_symbol(symbol) do
    Supervisor.start_child(__MODULE__, [symbol])
  end

  def init(:ok) do
    children = [
      worker(Ticker.Symbol, [], restart: :transient)
    ]
    supervise(children, strategy: :simple_one_for_one)
  end

end
