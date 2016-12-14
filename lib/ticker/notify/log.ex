require Logger

defmodule Ticker.Notify.Log do

  def info(list) do 
    Logger.info("Notify: #{inspect(list)}")
    :notifed
  end
  
end