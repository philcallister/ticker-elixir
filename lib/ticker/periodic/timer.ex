defmodule Ticker.Periodic.Timer do

  def quotes do
    Ticker.Quote.Processor.quotes |> Ticker.Notify.Quote.notify
  end

end