defmodule Ticker.Quote.Processor.Static do

  @behaviour Ticker.Quote.Processor.Behaviour
  @quote %Ticker.Quote{c: "-0.13", c_fix: "-0.13", ccol: "chr", cp: "-0.11", cp_fix: "-0.11", e: "NASDAQ", id: "22144", l: "113.59", l_cur: "113.59", l_fix: "113.59", lt: "Oct 31, 11:46AM EDT", lt_dts: "2016-10-31T11:46:02Z", ltt: "11:46AM EDT", pcls_fix: "113.72", s: "0"}

  @doc "Process the given symbols (@see Ticker.Quote.Processor.Behaviour.process). Used for testing"
  def process(symbols) do
    fake_quotes(symbols)
  end

  @doc "Process historical here (@see Ticker.Quote.Processor.Behaviour.historical). Used for testing"
  def historical(symbols) do
    fake_quotes(symbols)
  end

  defp fake_quotes(symbols) do
    Enum.map(symbols, fn(s) -> 
      Map.merge(@quote, %{t: s})
    end)
  end

end
