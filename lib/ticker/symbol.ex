require Logger

defmodule Ticker.Symbol do
  use GenServer

  ## Client API

  def start_link(symbol) do
    Logger.info("Starting Symbol: #{symbol}")
    GenServer.start_link(__MODULE__, :ok, name: symbol)
  end


  ## Server callbacks

  def init(:ok) do
    {:ok, %{}}
  end

end
