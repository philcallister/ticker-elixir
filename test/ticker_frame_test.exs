defmodule Ticker.Frame.Test do
  use ExUnit.Case, async: true

  @symbol "TSLA"
  @open_quote1 %Ticker.Quote{c: "+1.00", c_fix: "1.00", ccol: "chg", cp: "0.50",
      cp_fix: "0.50", e: "NASDAQ", id: "12607212", l: "200.00", l_cur: "200.00",
      l_fix: "200.00", lt: "Oct 21, 11:47AM EDT", lt_dts: "2016-10-21T11:47:05Z",
      ltt: "11:47AM EDT", pcls_fix: "198.0", s: "0", t: "TSLA"}
  @high_quote1 %Ticker.Quote{c: "+1.00", c_fix: "1.00", ccol: "chg", cp: "0.50",
      cp_fix: "0.50", e: "NASDAQ", id: "12607212", l: "202.00", l_cur: "202.00",
      l_fix: "202.00", lt: "Oct 21, 11:47AM EDT", lt_dts: "2016-10-21T11:47:10Z",
      ltt: "11:47AM EDT", pcls_fix: "198.0", s: "0", t: "TSLA"}
  @skip_quote1 %Ticker.Quote{c: "+1.00", c_fix: "1.00", ccol: "chg", cp: "0.50",
      cp_fix: "0.50", e: "NASDAQ", id: "12607212", l: "201.00", l_cur: "201.00",
      l_fix: "201.00", lt: "Oct 21, 11:47AM EDT", lt_dts: "2016-10-21T11:47:15Z",
      ltt: "11:47AM EDT", pcls_fix: "198.0", s: "0", t: "TSLA"}
  @close_quote1 %Ticker.Quote{c: "+1.00", c_fix: "1.00", ccol: "chg", cp: "0.50",
      cp_fix: "0.50", e: "NASDAQ", id: "12607212", l: "199.00", l_cur: "199.00",
      l_fix: "199.00", lt: "Oct 21, 11:47AM EDT", lt_dts: "2016-10-21T11:47:20Z",
      ltt: "11:47AM EDT", pcls_fix: "198.0", s: "0", t: "TSLA"}

  @open_quote2 %Ticker.Quote{c: "+1.00", c_fix: "1.00", ccol: "chg", cp: "0.50",
      cp_fix: "0.50", e: "NASDAQ", id: "12607212", l: "199.00", l_cur: "199.00",
      l_fix: "199.00", lt: "Oct 21, 11:48AM EDT", lt_dts: "2016-10-21T11:48:05Z",
      ltt: "11:48AM EDT", pcls_fix: "198.0", s: "0", t: "TSLA"}
  @high_quote2 %Ticker.Quote{c: "+1.00", c_fix: "1.00", ccol: "chg", cp: "0.50",
      cp_fix: "0.50", e: "NASDAQ", id: "12607212", l: "200.00", l_cur: "200.00",
      l_fix: "200.00", lt: "Oct 21, 11:48AM EDT", lt_dts: "2016-10-21T11:48:10Z",
      ltt: "11:48AM EDT", pcls_fix: "198.0", s: "0", t: "TSLA"}
  @low_quote2 %Ticker.Quote{c: "+1.00", c_fix: "1.00", ccol: "chg", cp: "0.50",
      cp_fix: "0.50", e: "NASDAQ", id: "12607212", l: "197.00", l_cur: "197.00",
      l_fix: "197.00", lt: "Oct 21, 11:48AM EDT", lt_dts: "2016-10-21T11:48:15Z",
      ltt: "11:48AM EDT", pcls_fix: "198.0", s: "0", t: "TSLA"}
  @close_quote2 %Ticker.Quote{c: "+1.00", c_fix: "1.00", ccol: "chg", cp: "0.50",
      cp_fix: "0.50", e: "NASDAQ", id: "12607212", l: "199.00", l_cur: "199.00",
      l_fix: "199.00", lt: "Oct 21, 11:48AM EDT", lt_dts: "2016-10-21T11:48:20Z",
      ltt: "11:48AM EDT", pcls_fix: "198.0", s: "0", t: "TSLA"}

  test "get empty frame from quotes" do
    frame = Ticker.Frame.quotes_to_frame(nil, nil, [])
    assert frame == %Ticker.Frame{}
  end

  test "convert quotes to frame" do
    frame = Ticker.Frame.quotes_to_frame(@symbol, 1, [@open_quote1, @high_quote1, @skip_quote1, @close_quote1])
    assert frame.open == @open_quote1
    assert frame.high == @high_quote1
    assert frame.low == @close_quote1
    assert frame.close == @close_quote1
  end

  test "bad quotes" do
    assert_raise(FunctionClauseError, "no function clause matching in Ticker.Frame.quotes_to_frame/3", fn -> 
      Ticker.Frame.quotes_to_frame(@symbol, 1, @open_quote1)
    end)
  end

  test "get empty frame from frames" do
    frame = Ticker.Frame.frames_to_frame(nil, nil, [])
    assert frame == %Ticker.Frame{}
  end

  test "convert frames to frame" do
    frame1 = Ticker.Frame.quotes_to_frame(@symbol, 1, [@open_quote1, @high_quote1, @skip_quote1, @close_quote1])
    frame2 = Ticker.Frame.quotes_to_frame(@symbol, 1, [@open_quote2, @high_quote2, @low_quote2, @close_quote2])
    frame = Ticker.Frame.frames_to_frame(@symbol, 2, [frame1, frame2])
    assert frame.open == @open_quote1
    assert frame.high == @high_quote1
    assert frame.low == @low_quote2
    assert frame.close == @close_quote2
  end

  test "bad frames" do
    frame = Ticker.Frame.quotes_to_frame(@symbol, 1, [@open_quote1, @high_quote1, @skip_quote1, @close_quote1])
    assert_raise(FunctionClauseError, "no function clause matching in Ticker.Frame.frames_to_frame/3", fn -> 
      Ticker.Frame.frames_to_frame(@symbol, 1, frame)
    end)
  end

end 