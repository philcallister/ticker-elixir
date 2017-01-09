defmodule Ticker.Symbol.Test do
  use ExUnit.Case, async: true

  @symbol "TSLA"
  @quote_start_minute %Ticker.Quote{c: "+1.02", c_fix: "1.02", ccol: "chg", cp: "0.51",
      cp_fix: "0.51", e: "NASDAQ", id: "12607212", l: "200.12", l_cur: "200.12",
      l_fix: "200.12", lt: "Oct 21, 11:46AM EDT", lt_dts: "2016-10-21T11:46:15Z",
      ltt: "11:46AM EDT", pcls_fix: "199.1", s: "0", t: "TSLA"}
  @quote_same_minute_1 %Ticker.Quote{c: "+1.02", c_fix: "1.02", ccol: "chg", cp: "0.51",
      cp_fix: "0.51", e: "NASDAQ", id: "12607212", l: "200.12", l_cur: "200.12",
      l_fix: "200.12", lt: "Oct 21, 11:47AM EDT", lt_dts: "2016-10-21T11:47:15Z",
      ltt: "11:47AM EDT", pcls_fix: "199.1", s: "0", t: "TSLA"}
  @quote_same_minute_2 %Ticker.Quote{c: "+1.03", c_fix: "1.03", ccol: "chg", cp: "0.52",
      cp_fix: "0.52", e: "NASDAQ", id: "12607212", l: "200.12", l_cur: "200.12",
      l_fix: "200.12", lt: "Oct 21, 11:47AM EDT", lt_dts: "2016-10-21T11:47:20Z",
      ltt: "11:47AM EDT", pcls_fix: "199.1", s: "0", t: "TSLA"}

  #####
  # Symbol Supervisor

  test "init supervisor" do
    Ticker.Symbol.Supervisor.start_link(@symbol)
    [symbol_pid | _] = :gproc.lookup_pids({:n, :l, {Ticker.Symbol, :"_"}})
    assert is_pid(symbol_pid)
    [time_frame_pid | _] = :gproc.lookup_pids({:n, :l, {Ticker.TimeFrame.Supervisor, :"_"}})
    assert is_pid(time_frame_pid)
  end


  #####
  # Symbol Client Interface

  test "init" do
    Ticker.Symbol.start_link(@symbol)
    [symbol_pid | _] = :gproc.lookup_pids({:n, :l, {Ticker.Symbol, :"_"}})
    assert is_pid(symbol_pid)
  end

  test "get pid" do
    {:ok, pid} = Ticker.Symbol.start_link(@symbol)
    test_pid = Ticker.Symbol.get_pid(@symbol)
    assert test_pid == pid
  end

  test "get symbol by pid" do
    {:ok, pid} = Ticker.Symbol.start_link(@symbol)
    test_symbol = Ticker.Symbol.get_symbol(pid)
    assert test_symbol == @symbol
  end

  test "get symbol by name" do
    {:ok, _} = Ticker.Symbol.start_link(@symbol)
    test_symbol = Ticker.Symbol.get_symbol(@symbol)
    assert test_symbol == @symbol
  end

  test "add/get quote" do
    {:ok, _} = Ticker.Symbol.start_link(@symbol)
    Ticker.Symbol.add_quote(@symbol, @quote_start_minute)
    test_quote = Ticker.Symbol.get_quote(@symbol)
    assert test_quote == @quote_start_minute
  end


  #####
  # Symbol Server Interface
  test "get symbol" do
    state = %{:symbol => @symbol, :quote => %Ticker.Quote{}}
    {:reply, response, newstate} = Ticker.Symbol.handle_call(:get_symbol, nil, state)
    assert newstate == state
    assert response == @symbol
  end

  test "get empty symbol" do
    state = %{:symbol => @symbol, :quote => %Ticker.Quote{}}
    {:reply, response, newstate} = Ticker.Symbol.handle_call(:get_symbol, nil, state)
    assert newstate == state
    assert response == @symbol
  end

  test "get empty quote" do
    quote = %Ticker.Quote{}
    state = %{:symbol => @symbol, :quote => %Ticker.Quote{}}
    {:reply, response, finalstate} = Ticker.Symbol.handle_call(:get_quote, nil, state)
    assert finalstate == state
    assert response == quote
  end

  test "get quote that has been set" do
    state = %{:symbol => @symbol, :quote => @quote_same_minute_1}
    {:reply, response, finalstate} = Ticker.Symbol.handle_call(:get_quote, nil, state)
    assert finalstate == state
    assert response == @quote_same_minute_1
  end

  test "add quote" do
    state = %{:symbol => @symbol, :quote => %Ticker.Quote{}, :quotes => [], :minute => nil}
    {:noreply, finalstate} = Ticker.Symbol.handle_cast({:add_quote, @quote_same_minute_1}, state)
    assert finalstate == %{:symbol => @symbol, :quote => @quote_same_minute_1, :quotes => [@quote_same_minute_1], :minute => 47}
  end

  test "add 2 quotes" do
    state = %{:symbol => @symbol, :quote => %Ticker.Quote{}, :quotes => [], :minute => nil}
    {:noreply, newstate} = Ticker.Symbol.handle_cast({:add_quote, @quote_same_minute_1}, state)
    {:noreply, finalstate} = Ticker.Symbol.handle_cast({:add_quote, @quote_same_minute_2}, newstate)
    assert finalstate == %{:symbol => @symbol, :quote => @quote_same_minute_2, :quotes => [@quote_same_minute_2, @quote_same_minute_1], :minute => 47}
  end

  test "add quote to next minute" do
    state = %{:symbol => @symbol, :quote => @quote_start_minute, :quotes => [], :minute => 46}
    {:noreply, finalstate} = Ticker.Symbol.handle_cast({:add_quote, @quote_same_minute_1}, state)
    assert finalstate == %{:symbol => @symbol, :quote => @quote_same_minute_1, :quotes => [@quote_same_minute_1], :minute => 47}
  end

end