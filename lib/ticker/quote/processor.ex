require Logger

defmodule Ticker.Quote.Processor do

  def quotes do
    Logger.info("Loading quotes...")
    symbol_servers = Supervisor.which_children(Ticker.Symbol.Supervisor)
    symbols = Enum.map(symbol_servers, fn({_, pid, _, _}) -> Ticker.Symbol.get_symbol(pid) end)
    process(symbols)
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
        Ticker.Symbol.Supervisor.add_symbol(q.t)
      end
      Ticker.Symbol.set_quote(q.t, q)
    end)
    {:ok, quotes}
  end

end
