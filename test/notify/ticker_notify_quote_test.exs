defmodule Ticker.Notify.Quote.Test do
  use ExUnit.Case, async: false

  @symbol "TSLA"
  @quote %Ticker.Quote{symbol: @symbol, marketPercent: "0.01024", bidSize: 100,
      bidPrice: "201.90", askSize: 100, askPrice: "202.10", volume: 33621,
      lastSalePrice: "199.00", lastSaleSize: 25,
      lastSaleTime: 1477050485000, lastUpdated: 1477050485000, lastReqTime: 1477050485000}

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