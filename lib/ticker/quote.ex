defmodule Ticker.Quote do
  @moduledoc """
  Quote Struct

  https://api.iextrading.com/1.0/tops?symbols=AAPL
  * symbol:        the stock ticker.
  * marketPercent: IEX's percentage of the market in the stock.
  * bidSize:       amount of shares on the bid on IEX.
  * bidPrice:      the best bid price on IEX.
  * askSize:       amount of shares on the ask on IEX.
  * askPrice:      the best ask price on IEX.
  * volume:        shares traded in the stock on IEX.
  * lastSalePrice: last sale price of the stock on IEX.
  * lastSaleSize:  last sale size of the stock on IEX.
  * lastSaleTime:  last sale time in epoch time of the stock on IEX.
  * lastUpdated:   the last update time of the data in milliseconds since midnight Jan 1, 1970 or -1. If the value is -1, IEX has not quoted the symbol in the trading day.
  * lastReqTime:   time of last request. This isn't returned from IEX but is used for interval framing
  """

  @derive [Poison.Encoder]
  defstruct [
    :symbol,
    :marketPercent,
    :bidSize,
    :bidPrice,
    :askSize,
    :askPrice,
    :volume,
    :lastSalePrice,
    :lastSaleSize,
    :lastSaleTime,
    :lastUpdated,
    :lastReqTime
  ]

  def is_a_quote?(%Ticker.Quote{}), do: true
  def is_a_quote?(_), do: false

  def as_type(ticker_quote, type \\ :string) do
    type_fn = case type do
      :string -> fn(value, sign, precision) -> as_string(value, sign, precision) end
      _       -> fn(value, _, _) -> as_float(value) end
    end

    %Ticker.Quote{
      symbol:         ticker_quote.symbol,
      marketPercent:  type_fn.(ticker_quote.marketPercent, false, 5),
      bidSize:        ticker_quote.bidSize,
      bidPrice:       type_fn.(ticker_quote.bidPrice, false, 3),
      askSize:        ticker_quote.askSize,
      askPrice:       type_fn.(ticker_quote.askPrice, false, 3),
      volume:         ticker_quote.volume,
      lastSalePrice:  type_fn.(ticker_quote.lastSalePrice, false, 3),
      lastSaleSize:   ticker_quote.lastSaleSize,
      lastSaleTime:   ticker_quote.lastSaleTime,
      lastUpdated:    ticker_quote.lastUpdated,
      lastReqTime:    ticker_quote.lastReqTime
    }

  end

  defp as_string(value, sign, precision) do
    pre = case sign do
      true when value > 0 -> "+"
      _ -> nil
    end
    ~s(#{pre}#{:erlang.float_to_binary(value, decimals: precision)})
  end

  defp as_float(value) do
    String.to_float(value)
  end

end
