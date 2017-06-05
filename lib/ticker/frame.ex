defmodule Ticker.Frame do
  @derive [Poison.Encoder]
  defstruct [
    :symbol,
    :interval,
    :open,
    :high,
    :low,
    :close
  ]

  def quotes_to_frame(_, _, []), do: %Ticker.Frame{}
  def quotes_to_frame(symbol, interval, quotes) when is_list(quotes) do
    Enum.reduce(quotes, %Ticker.Frame{symbol: symbol, interval: interval, open: hd(quotes), high: hd(quotes), low: hd(quotes), close: hd(quotes)}, fn(q, frame) ->
      %{frame | high: max_quote(frame.high, q), low: min_quote(frame.low, q), close: q}
    end)
  end

  def frames_to_frame(_, _, []), do: %Ticker.Frame{}
  def frames_to_frame(symbol, interval, frames) when is_list(frames) do
    Enum.reduce(frames, %Ticker.Frame{symbol: symbol, interval: interval, open: hd(frames).open, high: hd(frames).high, low: hd(frames).low, close: hd(frames).close}, fn(f, frame) ->
      %{frame | high: max_quote(frame.high, f.high), low: min_quote(frame.low, f.low), close: f.close}
    end)
  end

  defp min_quote(x,y) do
    case x.lastSalePrice <= y.lastSalePrice do
      true -> x
      _ -> y
    end
  end

  defp max_quote(x,y) do
    case x.lastSalePrice >= y.lastSalePrice do
      true -> x
      _ -> y
    end
  end

end
