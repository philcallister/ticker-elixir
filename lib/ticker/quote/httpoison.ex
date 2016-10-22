require Logger

defmodule Ticker.Quote.HTTPoison do

  @behaviour Ticker.Quote.Processor.Behaviour

  @doc "Process the given symbols (@see Ticker.Quote.Processor.Behaviour.process}"
  def process(symbols) do
    symbols
      |> fetch
      |> decode
      |> update
  end

  defp fetch(symbols) do
    case request(symbols) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> body
      {:ok, %HTTPoison.Response{status_code: 400}} -> Logger.error("Bad Request...")
      {:ok, %HTTPoison.Response{status_code: 404}} -> Logger.error("Not found...")
      {:error, %HTTPoison.Error{reason: reason}} -> IO.inspect reason
    end
  end

  defp request(symbols) do
    base_url = Application.get_env(:ticker, :url)
    params = Enum.join(symbols, "%2C")
    url = "#{base_url}#{params}"
    HTTPoison.get(url)
  end

  defp decode(body) do
    hacked_body = String.replace_leading(body, "\n// ", "")
    Poison.decode!(hacked_body, as: [%Ticker.Quote{}])
  end

  defp update(quotes) when is_list(quotes) do
    Enum.each(quotes, fn(q) ->
      if Ticker.Symbol.get_pid(q.t) == :undefined, do: Ticker.Symbol.Supervisor.add_symbol(q.t)
      Ticker.Symbol.set_quote(q.t, q)
    end)
  end

end
