defmodule Ticker.Quote.Processor.Simulate.Test do
  use ExUnit.Case, async: true

  @symbols ["TSLA", "GOOG"]

  setup_all do
    Ticker.Quote.Processor.Simulate.start_link
    :ok
  end

  test "process symbols" do
    {:ok, quotes} = Ticker.Quote.Processor.Simulate.process(@symbols)
    Enum.each(quotes, fn(q) -> assert Ticker.Quote.is_a_quote?(q) end)
  end

  test "historical quotes" do
    {:ok, quotes} = Ticker.Quote.Processor.Simulate.historical(@symbols)
    # 2 Symbols * 4 Quotes/Min * 120 Min = 960 Quotes
    assert length(quotes) == 960
    Enum.each(quotes, fn(q) -> assert Ticker.Quote.is_a_quote?(q) end)
  end

end
