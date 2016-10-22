require Logger

defmodule Ticker.Symbol do
  use GenServer

  ## Client API

  def start_link(name) do
    Logger.info("Starting Symbol: #{name}")
    GenServer.start_link(__MODULE__, {:ok, name}, name: via_tuple(name))
  end

  def get_pid(name) do
    :gproc.where({:n, :l, {__MODULE__, name}})
  end

  def get_symbol(pid) when is_pid(pid) do
    GenServer.call(pid, :get_symbol)
  end

  def get_symbol(name) do
    GenServer.call(via_tuple(name), :get_symbol)
  end

  def get_quote(name) do
    GenServer.call(via_tuple(name), :get_quote)
  end

  def set_quote(name, quote) when is_map(quote) do
    GenServer.cast(via_tuple(name), {:set_quote, quote})
  end

  defp via_tuple(name) do
    {:via, :gproc, {:n, :l, {__MODULE__, name}}}
  end


  ## Server callbacks

  def init({:ok, name}) do
    {:ok, %{:symbol => name, :quote => %Ticker.Quote{}}}
  end

  def handle_call(:get_symbol, _from, state) do
    {:reply, state[:symbol], state}
  end

  def handle_call(:get_quote, _from, state) do
    {:reply, state[:quote], state}
  end

  def handle_cast({:set_quote, quote}, state) do
    {:noreply, %{:symbol => state[:symbol], :quote => quote}}
  end

end
