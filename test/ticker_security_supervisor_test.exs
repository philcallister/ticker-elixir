defmodule Ticker.Security.Supervisor.Test do
  use ExUnit.Case, async: false

  setup_all do
    {:ok, _} = Registry.start_link(:unique, :process_registry)
    :ok
  end

  #####
  # Security Client Interface

  test "init no symbols" do
    {:ok, security_pid} = Ticker.Security.Supervisor.start_link(true)
    assert is_pid(security_pid)
    
    GenServer.stop(security_pid)
  end

  test "init symbols" do
    {:ok, security_pid} = Ticker.Security.Supervisor.start_link
    assert is_pid(security_pid)

    tsla_pid = Ticker.Symbol.get_pid("TSLA")
    assert is_pid(tsla_pid)

    goog_pid = Ticker.Symbol.get_pid("GOOG")
    assert is_pid(goog_pid)

    GenServer.stop(security_pid)
  end

end
