defmodule Ticker.Notify.Quote.Test do
  use ExUnit.Case, async: false

  @quote %Ticker.Quote{c: "+1.00", c_fix: "1.00", ccol: "chg", cp: "0.50",
    cp_fix: "0.50", e: "NASDAQ", id: "12607212", l: "199.00", l_cur: "199.00",
    l_fix: "199.00", lt: "Oct 21, 11:48AM EDT", lt_dts: "2016-10-21T11:48:05Z",
    ltt: "11:48AM EDT", pcls_fix: "198.0", s: "0", t: "TSLA"}

  def notify_quote_test_callback(quote) do
    assert quote == [@quote]
  end

  test "notify quote" do
    Application.put_env(:ticker, :quote_notify, [notify_module: Ticker.Notify.Quote.Test, notify_fn: :notify_quote_test_callback], [persistent: true])
    assert Ticker.Notify.Quote.notify({:ok, [@quote]}) == true
  end

  test "notify quote -- no module configured" do
    Application.put_env(:ticker, :quote_notify, [notify_module: nil, notify_fn: :notify_quote_test_callback], [persistent: true])
    assert Ticker.Notify.Quote.notify({:ok, [@quote]}) == :empty
  end

  test "notify quote -- no callback configured" do
    Application.put_env(:ticker, :quote_notify, [notify_module: Ticker.Notify.Quote.Test, notify_fn: :nil], [persistent: true])
    assert Ticker.Notify.Quote.notify({:ok, [@quote]}) == :empty
  end

end