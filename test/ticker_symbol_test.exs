defmodule Ticker.Symbol.Test do
  use ExUnit.Case, async: true

  @symbol "TSLA"
  @quote %Ticker.Quote{ c: "-4.46", c_fix: "-4.46", ccol: "chr", cp: "-2.19",
      cp_fix: "-2.19", div: "", e: "NASDAQ", ec: "-0.55", ec_fix: "-0.55",
      eccol: "chr", ecp: "-0.28", ecp_fix: "-0.28", el: "198.55", el_cur: "198.55",
      el_fix: "198.55", elt: "Oct 20, 7:59PM EDT", id: "12607212", l: "199.10",
      l_cur: "199.10", l_fix: "199.10", lt: "Oct 20, 4:00PM EDT",
      lt_dts: "2016-10-20T16:00:01Z", ltt: "4:00PM EDT", pcls_fix: "203.56", s: "2",
      t: "TSLA", yld: "" }

  test "get symbol" do
    state = %{:symbol => @symbol, :quote => %Ticker.Quote{}}
    {:reply, response, newstate} = Ticker.Symbol.handle_call(:get_symbol, nil, state)
    assert newstate == state
    assert response == @symbol
  end

  test "get empty quote" do
    quote = %Ticker.Quote{}
    state = %{:symbol => @symbol, :quote => %Ticker.Quote{}}
    {:reply, response, newstate} = Ticker.Symbol.handle_call(:get_quote, nil, state)
    assert newstate == state
    assert response == quote
  end

  test "get quote that has been set" do
    state = %{:symbol => @symbol, :quote => @quote}
    {:reply, response, newstate} = Ticker.Symbol.handle_call(:get_quote, nil, state)
    assert newstate == state
    assert response == @quote
  end

  test "set quote" do
    state = %{:symbol => @symbol, :quote => %Ticker.Quote{}}
    {:noreply, newstate} = Ticker.Symbol.handle_cast({:set_quote, @quote}, state)
    assert newstate == %{:symbol => @symbol, :quote => @quote}
  end

end