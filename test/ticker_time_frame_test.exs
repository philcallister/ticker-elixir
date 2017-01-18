defmodule Ticker.TimeFrame.Test do
  use ExUnit.Case, async: false

  @symbol "FB"
  @quote_1 %Ticker.Quote{c: "+1.02", c_fix: "1.02", ccol: "chg", cp: "0.51",
      cp_fix: "0.51", e: "NASDAQ", id: "12607212", l: "200.12", l_cur: "200.12",
      l_fix: "200.12", lt: "Oct 21, 11:46AM EDT", lt_dts: "2016-10-21T11:46:15Z",
      ltt: "11:46AM EDT", pcls_fix: "199.1", s: "0", t: @symbol}
  @quote_2 %Ticker.Quote{c: "+1.03", c_fix: "1.03", ccol: "chg", cp: "0.52",
      cp_fix: "0.52", e: "NASDAQ", id: "12607212", l: "200.12", l_cur: "200.12",
      l_fix: "200.12", lt: "Oct 21, 11:47AM EDT", lt_dts: "2016-10-21T11:47:20Z",
      ltt: "11:47AM EDT", pcls_fix: "199.1", s: "0", t: @symbol}

  @frame_1 %Ticker.Frame {
    symbol: @symbol,
    interval: 1,
    open: %Ticker.Quote{c: "+1.00", c_fix: "1.00", ccol: "chg", cp: "0.50",
        cp_fix: "0.50", e: "NASDAQ", id: "12607212", l: "199.00", l_cur: "199.00",
        l_fix: "199.00", lt: "Oct 21, 11:48AM EDT", lt_dts: "2016-10-21T11:48:05Z",
        ltt: "11:48AM EDT", pcls_fix: "198.0", s: "0", t: @symbol},
    high: %Ticker.Quote{c: "+1.00", c_fix: "1.00", ccol: "chg", cp: "0.50",
        cp_fix: "0.50", e: "NASDAQ", id: "12607212", l: "200.00", l_cur: "200.00",
        l_fix: "200.00", lt: "Oct 21, 11:48AM EDT", lt_dts: "2016-10-21T11:48:10Z",
        ltt: "11:48AM EDT", pcls_fix: "198.0", s: "0", t: @symbol},
    low: %Ticker.Quote{c: "+1.00", c_fix: "1.00", ccol: "chg", cp: "0.50",
        cp_fix: "0.50", e: "NASDAQ", id: "12607212", l: "197.00", l_cur: "197.00",
        l_fix: "197.00", lt: "Oct 21, 11:48AM EDT", lt_dts: "2016-10-21T11:48:15Z",
        ltt: "11:48AM EDT", pcls_fix: "198.0", s: "0", t: @symbol},
    close: %Ticker.Quote{c: "+1.00", c_fix: "1.00", ccol: "chg", cp: "0.50",
        cp_fix: "0.50", e: "NASDAQ", id: "12607212", l: "199.00", l_cur: "199.00",
        l_fix: "199.00", lt: "Oct 21, 11:48AM EDT", lt_dts: "2016-10-21T11:48:20Z",
        ltt: "11:48AM EDT", pcls_fix: "198.0", s: "0", t: @symbol}
  }

  @frame_2 %Ticker.Frame {
    symbol: @symbol,
    interval: 1,
    open: %Ticker.Quote{c: "+1.00", c_fix: "1.00", ccol: "chg", cp: "0.50",
        cp_fix: "0.50", e: "NASDAQ", id: "12607212", l: "199.00", l_cur: "199.00",
        l_fix: "199.00", lt: "Oct 21, 11:49AM EDT", lt_dts: "2016-10-21T11:49:05Z",
        ltt: "11:49AM EDT", pcls_fix: "198.0", s: "0", t: @symbol},
    high: %Ticker.Quote{c: "+1.00", c_fix: "1.00", ccol: "chg", cp: "0.50",
        cp_fix: "0.50", e: "NASDAQ", id: "12607212", l: "202.00", l_cur: "202.00",
        l_fix: "202.00", lt: "Oct 21, 11:49AM EDT", lt_dts: "2016-10-21T11:49:10Z",
        ltt: "11:49AM EDT", pcls_fix: "198.0", s: "0", t: @symbol},
    low: %Ticker.Quote{c: "+1.00", c_fix: "1.00", ccol: "chg", cp: "0.50",
        cp_fix: "0.50", e: "NASDAQ", id: "12607212", l: "199.00", l_cur: "199.00",
        l_fix: "199.00", lt: "Oct 21, 11:49AM EDT", lt_dts: "2016-10-21T11:49:15Z",
        ltt: "11:49AM EDT", pcls_fix: "198.0", s: "0", t: @symbol},
    close: %Ticker.Quote{c: "+1.00", c_fix: "1.00", ccol: "chg", cp: "0.50",
        cp_fix: "0.50", e: "NASDAQ", id: "12607212", l: "201.00", l_cur: "201.00",
        l_fix: "201.00", lt: "Oct 21, 11:49AM EDT", lt_dts: "2016-10-21T11:49:20Z",
        ltt: "11:49AM EDT", pcls_fix: "198.0", s: "0", t: @symbol}
  }

  @frame_rolled %Ticker.Frame {
    symbol: @symbol,
    interval: 2,
    open: %Ticker.Quote{c: "+1.00", c_fix: "1.00", ccol: "chg", cp: "0.50",
        cp_fix: "0.50", e: "NASDAQ", id: "12607212", l: "199.00", l_cur: "199.00",
        l_fix: "199.00", lt: "Oct 21, 11:48AM EDT", lt_dts: "2016-10-21T11:48:05Z",
        ltt: "11:48AM EDT", pcls_fix: "198.0", s: "0", t: @symbol},
    high: %Ticker.Quote{c: "+1.00", c_fix: "1.00", ccol: "chg", cp: "0.50",
        cp_fix: "0.50", e: "NASDAQ", id: "12607212", l: "202.00", l_cur: "202.00",
        l_fix: "202.00", lt: "Oct 21, 11:49AM EDT", lt_dts: "2016-10-21T11:49:10Z",
        ltt: "11:49AM EDT", pcls_fix: "198.0", s: "0", t: @symbol},
    low: %Ticker.Quote{c: "+1.00", c_fix: "1.00", ccol: "chg", cp: "0.50",
        cp_fix: "0.50", e: "NASDAQ", id: "12607212", l: "197.00", l_cur: "197.00",
        l_fix: "197.00", lt: "Oct 21, 11:48AM EDT", lt_dts: "2016-10-21T11:48:15Z",
        ltt: "11:48AM EDT", pcls_fix: "198.0", s: "0", t: @symbol},
    close: %Ticker.Quote{c: "+1.00", c_fix: "1.00", ccol: "chg", cp: "0.50",
        cp_fix: "0.50", e: "NASDAQ", id: "12607212", l: "201.00", l_cur: "201.00",
        l_fix: "201.00", lt: "Oct 21, 11:49AM EDT", lt_dts: "2016-10-21T11:49:20Z",
        ltt: "11:49AM EDT", pcls_fix: "198.0", s: "0", t: @symbol}
  }

  #####
  # TimeFrame Supervisor

  test "init supervisor" do
    {:ok, pid} = Ticker.TimeFrame.Supervisor.start_link(@symbol)
    time_frame_pids = :gproc.lookup_pids({:n, :l, {Ticker.TimeFrame, :"_", :"_"}})
    assert length(time_frame_pids) == length(Ticker.TimeFrame.Supervisor.intervals)
    Enum.each(time_frame_pids, fn(tfp) -> is_pid(tfp) end)
    GenServer.stop(pid)
  end


  #####
  # TimeFrame Client Interface

  test "init" do
    Ticker.TimeFrame.start_link(@symbol, {1, :none, [2,5]})
    [time_frame_pid | _] = :gproc.lookup_pids({:n, :l, {Ticker.TimeFrame, :"_", :"_"}})
    assert is_pid(time_frame_pid)
  end

  test "rollup quotes interface" do
    assert Ticker.TimeFrame.rollup_quotes(@symbol, [@quote_1, @quote_2]) == :ok
  end

  test "rollup frames interface" do
    assert Ticker.TimeFrame.rollup_frames(@symbol, 2, [@frame_1, @frame_2]) == :ok
  end

  test "get frames interface" do
    {:ok, pid} = Ticker.TimeFrame.Supervisor.start_link(@symbol)
    Ticker.TimeFrame.rollup_frames(@symbol, 2, [@frame_1, @frame_2])
    assert Ticker.TimeFrame.get_frames(@symbol, 2) == [@frame_rolled]
    GenServer.stop(pid)
  end


  #####
  # TimeFrame Server Interface

  # test "rollup quotes" do
  #   {:ok, pid1} = Ticker.TimeFrame.start_link(@symbol, {1, :none, [2,5]})
  #   {:ok, pid2} = Ticker.TimeFrame.start_link(@symbol, {2, 2, nil})

  #   state = %{:name => @symbol, :interval => 1, :frame_count => :none, :next_intervals => [2,5], :frames => [], :frame_key => 0}
  #   {:reply, response, newstate} = Ticker.TimeFrame.handle_cast({:rollup_quotes, [@quote_1, @quote_2]}, state)
  #   assert newstate == state
  #   assert response == @symbol

  #   GenServer.stop(pid1)
  #   GenServer.stop(pid2)
  # end

end