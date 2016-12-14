require Logger

defmodule Ticker.Symbol do
  use GenServer
  use Timex

  alias Ticker.TimeFrame

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

  def add_quote(name, quote) when is_map(quote) do
    GenServer.cast(via_tuple(name), {:add_quote, quote})
  end

  defp via_tuple(name) do
    {:via, :gproc, {:n, :l, {__MODULE__, name}}}
  end


  ## Server callbacks

  def init({:ok, name}) do
    {:ok, %{:symbol => name, :quote => %Ticker.Quote{}, :quotes => [], :minute => nil}}
  end

  def handle_call(:get_symbol, _from, state) do
    {:reply, state[:symbol], state}
  end

  def handle_call(:get_quote, _from, state) do
    {:reply, state[:quote], state}
  end

  def handle_cast({:add_quote, quote}, state) do
    {quotes, minute} = case set_quotes(quote, state[:minute]) do
      {:update, m} -> {[quote | state[:quotes]], m}
      {_, m} ->
        TimeFrame.rollup_quotes(quote.t, Enum.reverse(state[:quotes])) # New minute -- rollup previous minute
        {[quote], m}
    end
    {:noreply,  %{:symbol => state[:symbol], :quote => quote, :quotes => quotes, :minute => minute}}
  end

  defp set_quotes(quote, minute) do
    {:ok, quote_time} = Timex.parse(quote.lt_dts, "{ISO:Extended:Z}")
    cond do
      minute == nil -> {:update, quote_time.minute}
      quote_time.minute != minute -> {:reset, quote_time.minute}
      true -> {:update, minute}
    end
  end

end

defmodule Ticker.Symbol.Supervisor do
  use Supervisor

  def start_link(name) do
    Logger.info("Starting Symbol Supervisor: #{name}")
    Supervisor.start_link(__MODULE__, {:ok, name}, name: via_tuple(name))
  end

  defp via_tuple(name) do
    {:via, :gproc, {:n, :l, {__MODULE__, name}}}
  end


  ## Server callbacks

  def init({:ok, name}) do
    children = [
      supervisor(Ticker.TimeFrame.Supervisor, [name]),
      worker(Ticker.Symbol, [name])
    ]
    supervise(children, strategy: :one_for_one)
  end

end
