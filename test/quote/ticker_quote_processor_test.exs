defmodule Ticker.Quote.Processor.Test do
  use ExUnit.Case, async: false

  @symbol "TSLA"
  @quote %Ticker.Quote{c: "+1.00", c_fix: "1.00", ccol: "chg", cp: "0.50",
      cp_fix: "0.50", e: "NASDAQ", id: "12607212", l: "200.00", l_cur: "200.00",
      l_fix: "200.00", lt: "Oct 21, 11:47AM EDT", lt_dts: "2016-10-21T11:47:05Z",
      ltt: "11:47AM EDT", pcls_fix: "198.00", s: "0", t: "TSLA"}

  test "get historical" do
    {:ok, _} = Ticker.Symbol.start_link(@symbol)
    {:ok, [test_quote|_]} = Ticker.Quote.Processor.historical
    assert test_quote.t == @symbol
  end

  test "get empty historical" do
    assert Ticker.Quote.Processor.historical == {:empty}
  end

  test "get quotes" do
    {:ok, _} = Ticker.Symbol.start_link(@symbol)
    {:ok, [test_quote|_]} = Ticker.Quote.Processor.quotes
    assert test_quote.t == @symbol
  end

  test "get empty quotes" do
    assert Ticker.Quote.Processor.quotes == {:empty}
  end

  test "symbol updated" do
    {:ok, _} = Ticker.Symbol.start_link(@symbol)
    {:ok, [test_quote|_]} = Ticker.Quote.Processor.quotes
    assert Ticker.Symbol.get_quote(@symbol) == test_quote
  end

end 