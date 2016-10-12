require Logger

defmodule Ticker.Symbol do
  use GenServer

  ## Client API

  def start_link(symbol) do
    Logger.info("Starting Symbol: #{symbol}")
    GenServer.start_link(__MODULE__, {:ok, symbol}, name: symbol)
  end

  def symbol(pid) do
    GenServer.call(pid, :symbol)
  end


  ## Server callbacks

  def init({:ok, symbol}) do
    {:ok, %{:symbol => symbol}}
  end

  def handle_call(:symbol, _from, state) do
    {:reply, state[:symbol], state}
  end

end
