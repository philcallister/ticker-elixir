defmodule Ticker.TimeFrame.Test do
  use ExUnit.Case, async: false

  @symbol "FB"
  @quote_1 %Ticker.Quote{symbol: @symbol, marketPercent: "0.01024", bidSize: 100,
      bidPrice: "201.90", askSize: 100, askPrice: "202.10", volume: 33621,
      lastSalePrice: "200.12", lastSaleSize: 25,
      lastSaleTime: 1477050375000, lastUpdated: 1477050375000}
  @quote_2 %Ticker.Quote{symbol: @symbol, marketPercent: "0.01024", bidSize: 100,
      bidPrice: "201.90", askSize: 100, askPrice: "202.10", volume: 33621,
      lastSalePrice: "200.12", lastSaleSize: 25,
      lastSaleTime: 1477050440000, lastUpdated: 1477050440000}

  @frame_1 %Ticker.Frame {
    symbol: @symbol,
    interval: 1,
    open: %Ticker.Quote{symbol: @symbol, marketPercent: "0.01024", bidSize: 100,
      bidPrice: "201.90", askSize: 100, askPrice: "202.10", volume: 33621,
      lastSalePrice: "199.00", lastSaleSize: 25,
      lastSaleTime: 1477050485000, lastUpdated: 1477050485000},
    high: %Ticker.Quote{symbol: @symbol, marketPercent: "0.01024", bidSize: 100,
      bidPrice: "201.90", askSize: 100, askPrice: "202.10", volume: 33621,
      lastSalePrice: "200.00", lastSaleSize: 25,
      lastSaleTime: 1477050490000, lastUpdated: 1477050490000},
    low: %Ticker.Quote{symbol: @symbol, marketPercent: "0.01024", bidSize: 100,
      bidPrice: "201.90", askSize: 100, askPrice: "202.10", volume: 33621,
      lastSalePrice: "197.00", lastSaleSize: 25,
      lastSaleTime: 1477050495000, lastUpdated: 1477050495000},
    close: %Ticker.Quote{symbol: @symbol, marketPercent: "0.01024", bidSize: 100,
      bidPrice: "201.90", askSize: 100, askPrice: "202.10", volume: 33621,
      lastSalePrice: "199.00", lastSaleSize: 25,
      lastSaleTime: 1477050500000, lastUpdated: 1477050500000}
  }

  @frame_2 %Ticker.Frame {
    symbol: @symbol,
    interval: 1,
    open: %Ticker.Quote{symbol: @symbol, marketPercent: "0.01024", bidSize: 100,
      bidPrice: "201.90", askSize: 100, askPrice: "202.10", volume: 33621,
      lastSalePrice: "199.00", lastSaleSize: 25,
      lastSaleTime: 1477050545000, lastUpdated: 1477050545000},
    high: %Ticker.Quote{symbol: @symbol, marketPercent: "0.01024", bidSize: 100,
      bidPrice: "201.90", askSize: 100, askPrice: "202.10", volume: 33621,
      lastSalePrice: "202.00", lastSaleSize: 25,
      lastSaleTime: 1477050550000, lastUpdated: 1477050550000},
    low: %Ticker.Quote{symbol: @symbol, marketPercent: "0.01024", bidSize: 100,
      bidPrice: "201.90", askSize: 100, askPrice: "202.10", volume: 33621,
      lastSalePrice: "199.00", lastSaleSize: 25,
      lastSaleTime: 1477050555000, lastUpdated: 1477050555000},
    close: %Ticker.Quote{symbol: @symbol, marketPercent: "0.01024", bidSize: 100,
      bidPrice: "201.90", askSize: 100, askPrice: "202.10", volume: 33621,
      lastSalePrice: "201.00", lastSaleSize: 25,
      lastSaleTime: 1477050560000, lastUpdated: 1477050560000}
  }

  @frame_rolled %Ticker.Frame {
    symbol: @symbol,
    interval: 2,
    open: %Ticker.Quote{symbol: @symbol, marketPercent: "0.01024", bidSize: 100,
      bidPrice: "201.90", askSize: 100, askPrice: "202.10", volume: 33621,
      lastSalePrice: "199.00", lastSaleSize: 25,
      lastSaleTime: 1477050485000, lastUpdated: 1477050485000},
    high: %Ticker.Quote{symbol: @symbol, marketPercent: "0.01024", bidSize: 100,
      bidPrice: "201.90", askSize: 100, askPrice: "202.10", volume: 33621,
      lastSalePrice: "202.00", lastSaleSize: 25,
      lastSaleTime: 1477050550000, lastUpdated: 1477050550000},
    low: %Ticker.Quote{symbol: @symbol, marketPercent: "0.01024", bidSize: 100,
      bidPrice: "201.90", askSize: 100, askPrice: "202.10", volume: 33621,
      lastSalePrice: "197.00", lastSaleSize: 25,
      lastSaleTime: 1477050495000, lastUpdated: 1477050495000},
    close: %Ticker.Quote{symbol: @symbol, marketPercent: "0.01024", bidSize: 100,
      bidPrice: "201.90", askSize: 100, askPrice: "202.10", volume: 33621,
      lastSalePrice: "201.00", lastSaleSize: 25,
      lastSaleTime: 1477050560000, lastUpdated: 1477050560000}
  }

  setup_all do
    {:ok, _} = Registry.start_link(:unique, :process_registry)
    :ok
  end

  #####
  # TimeFrame Supervisor

  test "init supervisor" do
    {:ok, pid} = Ticker.TimeFrame.Supervisor.start_link(@symbol)
    time_frame_pids = Registry.match(:process_registry, {Ticker.TimeFrame, :_, :_}, :_)
    assert length(time_frame_pids) == length(Ticker.TimeFrame.Supervisor.intervals)
    Enum.each(time_frame_pids, fn({tfp, _}) -> is_pid(tfp) end)
    GenServer.stop(pid)
  end


  #####
  # TimeFrame Client Interface

  test "init" do
    Ticker.TimeFrame.start_link(@symbol, {1, :none, [2,5]})
    [{time_frame_pid, _} | _] = Registry.match(:process_registry, {Ticker.TimeFrame, :_, :_}, :_)
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

end