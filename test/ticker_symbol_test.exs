defmodule Ticker.Symbol.Test do
  use ExUnit.Case, async: true

  @symbol "TSLA"
  @quote %Ticker.Quote{c: "+1.02", c_fix: "1.02", ccol: "chg", cp: "0.51",
      cp_fix: "0.51", e: "NASDAQ", id: "12607212", l: "200.12", l_cur: "200.12",
      l_fix: "200.12", lt: "Oct 21, 11:47AM EDT", lt_dts: "2016-10-21T11:47:15Z",
      ltt: "11:47AM EDT", pcls_fix: "199.1", s: "0", t: "TSLA"}

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