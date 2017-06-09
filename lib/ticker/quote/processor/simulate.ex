defmodule Ticker.Quote.Processor.Simulate do

  use Timex
  alias Ticker.Quote.Util

  @historical_hours 2
  @ticks_per_minute 4
  @behaviour Ticker.Quote.Processor.Behaviour
  @initial_quote %Ticker.Quote{
    marketPercent: "0.0196",
    bidSize:       100,
    bidPrice:      "140.40",
    askSize:       50,
    askPrice:      "140.60",
    volume:        0,
    lastSalePrice: "140.50",
    lastSaleSize:  100,
    lastSaleTime:  "",
    lastUpdated:   ""
  }

  def start_link do
    Agent.start_link(fn -> @initial_quote end, name: __MODULE__)
  end

  @doc "Process the given symbols (@see Ticker.Quote.Processor.Behaviour.process}. Used for simulating quotes"
  def process(symbols) do
    quotes = process(symbols, Timex.now)
    {:ok, quotes}
  end

  @doc "Simulated historical quotes (@see Ticker.Quote.Processor.Behaviour.historical)"
  def historical(symbols) do
    dt = Timex.shift(Timex.now, hours: -@historical_hours)
    quotes = Interval.new(from: dt, until: [hours: @historical_hours], step: [minutes: 1])
      |> Enum.map(fn(i) -> Enum.map(1..@ticks_per_minute, fn(_) -> process(symbols, i) end) end)
      |> List.flatten
    {:ok, quotes}
  end

  defp process(symbols, date_time) do
    current_quote = get_quote()
    current_quote
      |> move_quote(date_time)
      |> set_quote
    Enum.map(symbols, fn(s) -> %{move_quote(current_quote, date_time) | symbol: s} end)
  end

  defp set_quote(new_value) do
    Agent.update(__MODULE__, fn(_) -> new_value end)
  end

  defp get_quote do
    Agent.get(__MODULE__, &(&1))
  end

  defp move_quote(from_quote, date_time) do
    initial_quote = Ticker.Quote.as_type(from_quote, :float)

    price = :rand.uniform()
      |> Float.round(2)
      |> Kernel.*(sim_pick([-1, 0, 0, 0, 1]))

    market_percent = initial_quote.marketPercent + 0.0001
    bid_size = sim_pick([25, 50, 75, 100, 200])
    bid_price = initial_quote.bidPrice + price
    ask_size = sim_pick([25, 50, 75, 100, 200])
    ask_price = initial_quote.askPrice + price
    volume = initial_quote.volume + initial_quote.lastSaleSize
    last_sale_price = initial_quote.lastSalePrice + price
    last_sale_size = sim_pick([25, 50, 75, 100, 200])
    last_sale_time = Timex.shift(date_time, seconds: sim_pick([-1, 0])) |> Util.to_unix_milli
    last_updated = Util.to_unix_milli(date_time)

    to_quote = %{@initial_quote |
      marketPercent: market_percent,
      bidSize:       bid_size,
      bidPrice:      bid_price,
      askSize:       ask_size,
      askPrice:      ask_price,
      volume:        volume,
      lastSalePrice: last_sale_price,
      lastSaleSize:  last_sale_size,
      lastSaleTime:  last_sale_time,
      lastUpdated:   last_updated,
      lastReqTime:   last_updated
    }

    Ticker.Quote.as_type(to_quote, :string)
  end

  defp sim_pick(pick) do
    Enum.random(pick)
  end

end
