defmodule Ticker.Periodic.Timer do

  def quotes(startup) when startup do
    historical = Application.get_env(:ticker, :historical)
    case historical do
        true -> Ticker.Quote.Processor.historical
        _ -> quotes(false)
    end
  end

  def quotes(_) do
    Ticker.Quote.Processor.quotes |> Ticker.Notify.Quote.notify
  end

end
