defmodule Ticker.Periodic.Periodically.Test do
  use ExUnit.Case, async: false

  test "periodic worker runs immediately & interval" do
    test_pid = self()
    worker_callback = fn(_) -> send(test_pid, {:called_back}) end
    {:ok, periodically_pid} = Ticker.Periodic.Periodically.start_link(worker_callback, 1000)

    # Should get 2 callbacks
    assert_receive({:called_back}, 1000)  # on start
    assert_receive({:called_back}, 1_500) # 1000 interval

    GenServer.stop(periodically_pid)
  end

  test "periodic worker only runs @ interval" do
    test_pid = self()
    worker_callback = fn(_) -> send(test_pid, {:called_back}) end
    {:ok, periodically_pid} = Ticker.Periodic.Periodically.start_link(worker_callback, 1000, false)

    # Should get only 1 callback
    assert_receive({:called_back}, 1_500) # 1000 interval
    refute_received({:called_back})

    GenServer.stop(periodically_pid)
  end

end