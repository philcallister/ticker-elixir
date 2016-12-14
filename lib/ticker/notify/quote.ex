defmodule Ticker.Notify.Quote do

  def notify({:ok, quotes}) do
    notify_conf = Application.get_env(:ticker, :quote_notify)

    case notify_conf[:notify_module] do
      nil -> :empty
      :none -> :empty
      _ ->
        case notify_conf[:notify_fn] do
          nil -> :empty
          :none -> :empty
          _ -> apply(notify_conf[:notify_module], notify_conf[:notify_fn], [quotes])
        end
    end
  end

  def notify(_), do: :empty

end