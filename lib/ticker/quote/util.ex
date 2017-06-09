defmodule Ticker.Quote.Util do

  def to_unix_milli(dt) do
    DateTime.to_unix(Timex.to_datetime(dt), :milliseconds)
  end

end
