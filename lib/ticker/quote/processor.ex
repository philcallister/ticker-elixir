require Logger

defmodule Ticker.Quote.Processor do

  def quotes do
    Logger.info("Loading quotes...")
    symbol_servers = :gproc.lookup_pids({:n, :l, {Ticker.Symbol, :"_"}})
    Enum.map(symbol_servers, fn(ss) -> Ticker.Symbol.get_symbol(ss) end) |> process
  end

  defp process([]) do
    Logger.info("No available symbols...")
    {:empty}
  end

  defp process(symbols) do
    processor = Application.get_env(:ticker, :processor)
    symbols
      |> processor.process
      |> update
  end

  defp update([]), do: Logger.info("No available quotes...")

  defp update(quotes) do
    Enum.each(quotes, fn(q) ->
      if Ticker.Symbol.get_pid(q.t) == :undefined do
        Ticker.Security.Supervisor.add_security(q.t)
      end
      Ticker.Symbol.add_quote(q.t, q)
    end)
    {:ok, quotes}
  end

end
