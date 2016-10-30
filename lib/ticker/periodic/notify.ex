require Logger

defmodule Ticker.Periodic.Notify do
  def on(quotes) do 
    Logger.info("Notify Quotes: #{inspect(quotes)}")
    :notifed
  end
end