require Logger

defmodule Ticker.Quote.Processor do
  use GenServer

  @processor Application.get_env(:ticker, :processor)


  ## Client API

  def start_link do
    Logger.info("Starting Quote Processor...")
    HTTPoison.start
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def quotes do
    Logger.info("Loading quotes...")
    GenServer.cast(__MODULE__, :quotes)
  end


  ## Server callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_cast(:quotes, state) do
    symbol_servers = Supervisor.which_children(Ticker.Symbol.Supervisor)
    symbols = Enum.map(symbol_servers, fn({_, pid, _, _}) -> Ticker.Symbol.get_symbol(pid) end)
    @processor.process(symbols)
    {:noreply, state}
  end

end
