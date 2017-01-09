defmodule Ticker.Quote.Test do
  use ExUnit.Case, async: true

  @quote_string %Ticker.Quote{c: "+1.00", c_fix: "1.00", ccol: "chg", cp: "0.50",
      cp_fix: "0.50", e: "NASDAQ", id: "12607212", l: "200.00", l_cur: "200.00",
      l_fix: "200.00", lt: "Oct 21, 11:47AM EDT", lt_dts: "2016-10-21T11:47:05Z",
      ltt: "11:47AM EDT", pcls_fix: "198.00", s: "0", t: "TSLA"}

  @quote_float %Ticker.Quote{c: 1.00, c_fix: 1.00, ccol: "chg", cp: 0.50,
      cp_fix: 0.50, e: "NASDAQ", id: "12607212", l: 200.00, l_cur: 200.00,
      l_fix: 200.00, lt: "Oct 21, 11:47AM EDT", lt_dts: "2016-10-21T11:47:05Z",
      ltt: "11:47AM EDT", pcls_fix: 198.00, s: "0", t: "TSLA"}

  test "quote from string to float" do
    quote_float = Ticker.Quote.as_type(@quote_string, :float)
    assert quote_float == @quote_float
  end

  test "quote from float to string" do
    quote_string = Ticker.Quote.as_type(@quote_float)
    assert quote_string == @quote_string
  end

end 