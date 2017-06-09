defmodule Ticker.Quote.Processor.Test do
  use ExUnit.Case, async: false

  @symbol "TSLA"
  @unexpected_symbol "YIKE"
  @unexpected_quote %Ticker.Quote{symbol: @unexpected_symbol, marketPercent: "0.01024", bidSize: 100,
      bidPrice: "201.90", askSize: 100, askPrice: "202.10", volume: 33621,
      lastSalePrice: "200.00", lastSaleSize: 25,
      lastSaleTime: 1477050375000, lastUpdated: 1477050375000, lastReqTime: 1477050375000}

  setup_all do
    {:ok, _} = Registry.start_link(:unique, :process_registry)
    :ok
  end

  test "get historical" do
    {:ok, _} = Ticker.Symbol.start_link(@symbol)
    {:ok, [test_quote|_]} = Ticker.Quote.Processor.historical
    assert test_quote.symbol == @symbol
  end

  test "get empty historical" do
    assert Ticker.Quote.Processor.historical == {:empty}
  end

  test "get quotes" do
    {:ok, _} = Ticker.Symbol.start_link(@symbol)
    {:ok, [test_quote|_]} = Ticker.Quote.Processor.quotes
    assert test_quote.symbol == @symbol
  end

  test "get empty quotes" do
    assert Ticker.Quote.Processor.quotes == {:empty}
  end

  test "quote updated" do
    {:ok, _} = Ticker.Symbol.start_link(@symbol)
    {:ok, [test_quote|_]} = Ticker.Quote.Processor.quotes
    assert Ticker.Symbol.get_quote(@symbol) == test_quote
  end

  test "update unexpected quote" do
    {:ok, security_pid} = Ticker.Security.Supervisor.start_link(true)
    Ticker.Quote.Processor.update({:ok, [@unexpected_quote]})
    assert Ticker.Symbol.get_quote(@unexpected_symbol) == @unexpected_quote
    GenServer.stop(security_pid)
  end

  test "no quote to update" do
    assert Ticker.Quote.Processor.update({:ok, []}) == :ok
  end

  test "update error" do
    assert Ticker.Quote.Processor.update({:error, "error"}) == :ok
  end

end
