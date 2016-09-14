require Logger

defmodule Ticker.SymbolConfig do

  def add_config_symbols do
    symbols = Application.get_env(:ticker, :symbols)
    Enum.each(symbols, fn(s) -> Ticker.SymbolSupervisor.add_symbol(s) end)
  end

end
