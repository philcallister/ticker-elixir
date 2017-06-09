defmodule Ticker.Quote.Processor.Static do
  @behaviour Ticker.Quote.Processor.Behaviour

  @initial_quote %Ticker.Quote{
    marketPercent: "0.0196",
    bidSize:       "100",
    bidPrice:      "140.40",
    askSize:       "50",
    askPrice:      "140.60",
    volume:        "300000",
    lastSalePrice: "140.50",
    lastSaleSize:  "100",
    lastSaleTime:  1477050375000,
    lastUpdated:   1477050375000,
    lastReqTime:   1477050375000
  }

  @doc "Process the given symbols (@see Ticker.Quote.Processor.Behaviour.process). Used for testing"
  def process(symbols) do
    fake_quotes(symbols)
  end

  @doc "Process historical here (@see Ticker.Quote.Processor.Behaviour.historical). Used for testing"
  def historical(symbols) do
    fake_quotes(symbols)
  end

  defp fake_quotes(symbols) do
    quotes = Enum.map(symbols, fn(s) ->
      Map.merge(@initial_quote, %{symbol: s})
    end)
    {:ok, quotes}
  end

end
