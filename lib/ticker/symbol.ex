require Logger

defmodule Ticker.Symbol do
  use GenServer

  ## Client API

  def start_link(name) do
    Logger.info("Starting Symbol: #{name}")
    GenServer.start_link(__MODULE__, {:ok, name}, name: via_tuple(name))
  end

  def symbol(pid) when is_pid(pid) do
    GenServer.call(pid, :symbol)
  end

  def symbol(name) do
    GenServer.call(via_tuple(name), :symbol)
  end

  defp via_tuple(name) do
    {:via, :gproc, {:n, :l, {__MODULE__, name}}}
  end


  ## Server callbacks

  def init({:ok, name}) do
    {:ok, %{:symbol => name}}
  end

  def handle_call(:symbol, _from, state) do
    {:reply, state[:symbol], state}
  end

end
