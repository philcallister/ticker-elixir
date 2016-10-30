defmodule Ticker.Periodic.Timer do

  def on do
    notify(Ticker.Quote.Processor.quotes)
  end

  defp notify({:ok, quotes}) do
    notify_mod = Application.get_env(:ticker, :notify_module)
    notify_fn = Application.get_env(:ticker, :notify_fn)

    case notify_mod do
      :none -> :empty
      _ ->
        case notify_fn do
          :none -> :empty
          _ -> apply(notify_mod, notify_fn, [quotes])
        end
    end
  end

  defp notify(_), do: :empty

end