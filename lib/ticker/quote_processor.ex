require Logger

defmodule Ticker.QuoteProcessor do
  use GenServer

  ## Client API

  def start_link do
    Logger.info("Starting Quote Processor...")
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def quotes do
    GenServer.cast(__MODULE__, :quotes)
  end


  ## Server callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_cast(:quotes, state) do
    symbol_servers = Supervisor.which_children(Ticker.SymbolSupervisor)
    symbols = Enum.map(symbol_servers, fn({_, pid, _, _}) -> GenServer.call(pid, :symbol) end)
    update_quotes(symbols)

    {:noreply, state}
  end

  defp update_quotes(symbols) do
    params = Enum.join(symbols, "%2C")
    url = "http://finance.google.com/finance/info?client=ig&q=NASDAQ%3A#{params}"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> process(body)
      {:ok, %HTTPoison.Response{status_code: 400}} -> IO.puts "Bad Request..."
      {:ok, %HTTPoison.Response{status_code: 404}} -> IO.puts "Not found..."
      {:error, %HTTPoison.Error{reason: reason}} -> IO.inspect reason
    end
  end

  defp process(body) do
    hacked_body = String.replace_leading(body, "\n// ", "")
    parsed = Poison.decode!(hacked_body)
    as =
      cond do
        is_map(parsed) -> %Ticker.Quote{}
        is_list(parsed) -> [%Ticker.Quote{}]
      end
    decoded = Poison.Decoder.decode(parsed, as: as)
    IO.puts(inspect(decoded))
  end

end
