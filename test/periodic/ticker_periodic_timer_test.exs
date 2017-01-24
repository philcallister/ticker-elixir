defmodule Ticker.Periodic.Timer.Test do
  use ExUnit.Case, async: false

  setup_all do
    {:ok, _} = Registry.start_link(:unique, :process_registry)
    :ok
  end

  test "timer quotes startup" do
    Application.put_env(:ticker, :historical, true, [persistent: true])
    assert Ticker.Periodic.Timer.quotes(true) == {:empty}
  end

  test "timer quotes no historical" do
    Application.put_env(:ticker, :historical, false, [persistent: true])
    Application.put_env(:ticker, :quote_notify, [notify_module: :none, notify_fn: :none], [persistent: true])
    assert Ticker.Periodic.Timer.quotes(true) == :empty
  end

  test "timer quotes no startup" do
    Application.put_env(:ticker, :quote_notify, [notify_module: :none, notify_fn: :none], [persistent: true])
    assert Ticker.Periodic.Timer.quotes(false) == :empty
  end

end