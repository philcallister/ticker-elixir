require Logger

defmodule Ticker.QuoteProcessor do
  use GenServer

  ## Client API

  def start_link do
    Logger.info("Starting Quote Processor...")
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def quote(pid) do
    GenServer.cast(pid, {:quote})
  end


  ## Server callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_cast(:quote, state) do
    symbol_servers = Supervisor.which_children(Ticker.SymbolSupervisor)
    symbols = Enum.map(symbol_servers, fn({_, pid, _, _}) -> GenServer.call(pid, :symbol) end)
    generate_quote(symbols)
    {:noreply, state}
  end

  defp generate_quote(symbols) do
    params = symbols
      |> Enum.map(fn(s) -> "%22#{s}%22" end) 
      |> Enum.join("%2C")
    url = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(#{params})&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
    IO.puts(inspect(HTTPoison.get! url))
  end

end
