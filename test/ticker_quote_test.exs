defmodule Ticker.Quote.Test do
  use ExUnit.Case, async: true

  @symbol "TSLA"
  @quote_string %Ticker.Quote{symbol: @symbol, marketPercent: "0.01024", bidSize: 100,
      bidPrice: "201.900", askSize: 100, askPrice: "202.100", volume: 33621,
      lastSalePrice: "200.000", lastSaleSize: 25,
      lastSaleTime: 1477050425000, lastUpdated: 1477050425000, lastReqTime: 1477050425000}

  @quote_float %Ticker.Quote{symbol: @symbol, marketPercent: 0.01024, bidSize: 100,
      bidPrice: 201.90, askSize: 100, askPrice: 202.10, volume: 33621,
      lastSalePrice: 200.00, lastSaleSize: 25,
      lastSaleTime: 1477050425000, lastUpdated: 1477050425000, lastReqTime: 1477050425000}

  test "quote from string to float" do
    quote_float = Ticker.Quote.as_type(@quote_string, :float)
    assert quote_float == @quote_float
  end

  test "quote from float to string" do
    quote_string = Ticker.Quote.as_type(@quote_float)
    assert quote_string == @quote_string
  end

end 