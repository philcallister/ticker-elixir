require Logger

defmodule Ticker.Quote.Processor.HTTP do

  @behaviour Ticker.Quote.Processor.Behaviour

  @doc "Process the given symbols (@see Ticker.Quote.Processor.Behaviour.process}"
  def process(symbols) do
    symbols
      |> fetch
      |> decode
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

end
