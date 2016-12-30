defmodule Ticker.Quote.Processor.Simulate do

  use Timex

  @historical_hours 2
  @behaviour Ticker.Quote.Processor.Behaviour
  @initial_quote %Ticker.Quote{c: "0.00", c_fix: "0.00", ccol: "chr", cp: "0.00", cp_fix: "0.00", e: "NASDAQ", id: "99999", l: "120.00", l_cur: "120.00", l_fix: "120.00", lt: "", lt_dts: "", ltt: "", pcls_fix: "120.00", s: "0"}

  def start_link do
    Agent.start_link(fn -> @initial_quote end, name: __MODULE__)
  end

  @doc "Process the given symbols (@see Ticker.Quote.Processor.Behaviour.process}. Used for simulating quotes"
  def process(symbols) do
    process(symbols, Timex.now)
  end

  @doc "Simulated historical quotes (@see Ticker.Quote.Processor.Behaviour.historical)"
  def historical(symbols) do
    dt = Timex.shift(Timex.now, hours: -@historical_hours)
    Interval.new(from: dt, until: [hours: @historical_hours], step: [minutes: 1])
      |> Enum.map(fn(i) -> Enum.map(1..4, fn(_) -> process(symbols, i) end) end)
      |> List.flatten
  end

  defp process(symbols, date_time) do
    current_quote = get_quote()
    current_quote
      |> move_quote(date_time)
      |> set_quote
    Enum.map(symbols, fn(s) -> %{move_quote(current_quote, date_time) | t: s} end)
  end

  defp set_quote(new_value) do
    Agent.update(__MODULE__, fn(_) -> new_value end)
  end

  defp get_quote do
    Agent.get(__MODULE__, &(&1))
  end

  defp move_quote(from_quote, date_time) do
    initial_quote = from_quote |> Ticker.Quote.as_type(:float)
    direction = Enum.random([-1, 0, 0, 0, 1])
    delta = :rand.uniform()
      |> Float.round(2)
      |> Kernel.*(direction)
    initial_price = initial_quote.pcls_fix
    current_price = initial_quote.l + delta
    change_price = current_price - initial_price
    change_pct = (change_price / initial_price) * 100
    {lt, ltt, lt_dts} = date_fields(date_time)
    to_quote = %{@initial_quote | c: change_price, c_fix: change_price, cp: change_pct, cp_fix: change_pct, l: current_price, l_cur: current_price, l_fix: current_price, lt: lt, lt_dts: lt_dts, ltt: ltt, pcls_fix: String.to_float(@initial_quote.pcls_fix)}
    Ticker.Quote.as_type(to_quote, :string)
  end

  defp date_fields(date_time) do
    tz = Timezone.get("America/New_York", date_time)
    edt = Timezone.convert(date_time, tz)
    ltt = ~s(#{Timex.format!(edt, "%I:%M%p", :strftime)} #{tz.abbreviation})
    lt = ~s(#{Timex.format!(edt, "%b %d, %I:%M%p", :strftime)} #{tz.abbreviation})
    lt_dts = ~s(#{Timex.format!(date_time, "%FT%T", :strftime)}Z)
    {lt, ltt, lt_dts}
  end

end
