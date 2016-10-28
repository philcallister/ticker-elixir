defmodule Ticker.Quote.Processor.Static do

  @behaviour Ticker.Quote.Processor.Behaviour
  @quote %Ticker.Quote {c: "+0.99", c_fix: "0.99", ccol: "chg", cp: "0.50", cp_fix: "0.50", e: "NASDAQ", id: "12607212", l: "200.09", l_cur: "200.09", l_fix: "200.09", lt: "Oct 21, 4:00PM EDT", lt_dts: "2016-10-21T16:00:02Z", ltt: "4:00PM EDT", pcls_fix: "199.1", s: "0"}

  @doc "Process the given symbols (@see Ticker.Quote.Processor.Behaviour.process}. Used for testing"
  def process(symbols) do
    Enum.map(symbols, fn(s) -> 
      Map.merge(@quote, %{t: s})
    end)
  end

end
