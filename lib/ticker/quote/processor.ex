require Logger

defmodule Ticker.Quote.Processor do
  use GenServer

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
    {:ok, nil}
  end

  def handle_cast(:quotes, state) do
    processor = Application.get_env(:ticker, :processor)
    symbol_servers = Supervisor.which_children(Ticker.Symbol.Supervisor)
    symbols = Enum.map(symbol_servers, fn({_, pid, _, _}) -> Ticker.Symbol.get_symbol(pid) end)
    symbols
      |> processor.process
      |> update
    {:noreply, state}
  end

  defp update(quotes) do
    Enum.each(quotes, fn(q) ->
      if Ticker.Symbol.get_pid(q.t) == :undefined do
        Ticker.Symbol.Supervisor.add_symbol(q.t)
      end
      Ticker.Symbol.set_quote(q.t, q)
    end)
  end

end
