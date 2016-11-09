defmodule Ticker.Quote.Processor.Simulate do

  use Timex

  @behaviour Ticker.Quote.Processor.Behaviour
  @initial_quote %Ticker.Quote{c: "0.00", c_fix: "0.00", ccol: "chr", cp: "0.00", cp_fix: "0.00", e: "NASDAQ", id: "99999", l: "120.00", l_cur: "120.00", l_fix: "120.00", lt: "", lt_dts: "", ltt: "", pcls_fix: "120.00", s: "0"}

  def start_link do
    Agent.start_link(fn -> @initial_quote end, name: __MODULE__)
  end

  @doc "Process the given symbols (@see Ticker.Quote.Processor.Behaviour.process}. Used for simulating quotes"
  def process(symbols) do
    current_quote = get_quote()
    current_quote
      |> move_quote()
      |> set_quote()
    Enum.map(symbols, fn(s) ->
      Map.merge(move_quote(current_quote), %{t: s})
    end)
  end

  defp set_quote(new_value) do
    Agent.update(__MODULE__, fn(_) -> new_value end)
  end

  defp get_quote do
    Agent.get(__MODULE__, &(&1))
  end

  defp move_quote(from_quote) do
    initial_quote = from_quote |> Ticker.Quote.as_type(:float)
    direction = Enum.random([-1, 1])
    delta = :rand.uniform()
      |> Float.round(2)
      |> Kernel.*(direction)
    initial_price = initial_quote.pcls_fix
    current_price = initial_quote.l + delta
    change_price = current_price - initial_price
    change_pct = (change_price / initial_price) * 100
    {lt, ltt, lt_dts} = date_fields()
    to_quote = %{@initial_quote | c: change_price, c_fix: change_price, cp: change_pct, cp_fix: change_pct, l: current_price, l_cur: current_price, l_fix: current_price, lt: lt, lt_dts: lt_dts, ltt: ltt, pcls_fix: String.to_float(@initial_quote.pcls_fix)}
    Ticker.Quote.as_type(to_quote, :string)
  end

  defp date_fields do
    dt = Timex.now
    tz = Timezone.get("America/New_York", dt)
    edt = Timezone.convert(dt, tz)
    ltt = ~s(#{Timex.format!(edt, "%I:%M%p", :strftime)} #{tz.abbreviation})
    lt = ~s(#{Timex.format!(edt, "%b %d, %I:%M%p", :strftime)} #{tz.abbreviation})
    lt_dts = ~s(#{Timex.format!(dt, "%FT%T", :strftime)}Z)
    {lt, ltt, lt_dts}
  end

end
