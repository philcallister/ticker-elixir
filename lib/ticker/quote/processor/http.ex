require Logger

defmodule Ticker.Quote.Processor.HTTP do

  @behaviour Ticker.Quote.Processor.Behaviour

  @doc "Process the given symbols (@see Ticker.Quote.Processor.Behaviour.process}"
  def process(symbols) do
    symbols
      |> fetch
      |> decode
  end

  @doc "Currently historical not implemented here (@see Ticker.Quote.Processor.Behaviour.historical)"
  def historical(_), do: []

  defp fetch(symbols) do
    case request(symbols) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> {:ok, body}
      {:ok, %HTTPoison.Response{status_code: 400}} -> {:error, "Bad Request..."}
      {:ok, %HTTPoison.Response{status_code: 404}} -> {:error, "Not Found..."}
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, IO.inspect reason}
    end
  end

  defp request(symbols) do
    base_url = Application.get_env(:ticker, :url)
    params = Enum.join(symbols, "%2C")
    url = "#{base_url}#{params}"
    HTTPoison.get(url)
  end

  defp decode({:error, _} = ret) do
    ret
  end

  defp decode({:ok, body}) do
    {:ok, Poison.decode!(body, as: [%Ticker.Quote{}])}
  end

end
