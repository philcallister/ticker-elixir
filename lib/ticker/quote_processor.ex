require Logger

defmodule Ticker.QuoteProcessor do
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
    {:ok, %{}}
  end

  def handle_cast(:quotes, state) do
    symbol_servers = Supervisor.which_children(Ticker.SymbolSupervisor)
    symbols = Enum.map(symbol_servers, fn({_, pid, _, _}) -> Ticker.Symbol.get_symbol(pid) end)
    symbols
      |> fetch
      |> decode
      |> update
    {:noreply, state}
  end

  defp fetch(symbols) do
    base_url = Application.get_env(:ticker, :url)
    params = Enum.join(symbols, "%2C")
    url = "#{base_url}#{params}"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> body
      {:ok, %HTTPoison.Response{status_code: 400}} -> Logger.error("Bad Request...")
      {:ok, %HTTPoison.Response{status_code: 404}} -> Logger.error("Not found...")
      {:error, %HTTPoison.Error{reason: reason}} -> IO.inspect reason
    end
  end

  defp decode(body) do
    hacked_body = String.replace_leading(body, "\n// ", "")
    Poison.decode!(hacked_body, as: [%Ticker.Quote{}])
  end

  defp update(quotes) when is_list(quotes) do
    Enum.each(quotes, fn(q) -> Ticker.Symbol.set_quote(q.t, q) end)
  end

end
