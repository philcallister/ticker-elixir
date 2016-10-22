require Logger

defmodule Ticker.Symbol.Supervisor do
  use Supervisor

  def start_link do
    Logger.info("Starting Symbol Supervisor...")
    {:ok, pid} = Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
    add_config_symbols
    {:ok, pid}
  end

  def add_symbol(symbol) do
    Supervisor.start_child(__MODULE__, [symbol])
  end

  def add_symbols(symbols) do
    Enum.each(symbols, fn(s) -> add_symbol(s) end)
  end

  def init(:ok) do
    children = [
      worker(Ticker.Symbol, [], restart: :transient)
    ]
    supervise(children, strategy: :simple_one_for_one)
  end

  defp add_config_symbols do
    symbols = Application.get_env(:ticker, :symbols)
    add_symbols(symbols)
  end

end
