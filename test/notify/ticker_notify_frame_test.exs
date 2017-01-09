defmodule Ticker.Notify.Frame.Test do
  use ExUnit.Case, async: false

  @frame %Ticker.Frame {
    open: %Ticker.Quote{c: "+1.00", c_fix: "1.00", ccol: "chg", cp: "0.50",
        cp_fix: "0.50", e: "NASDAQ", id: "12607212", l: "199.00", l_cur: "199.00",
        l_fix: "199.00", lt: "Oct 21, 11:48AM EDT", lt_dts: "2016-10-21T11:48:05Z",
        ltt: "11:48AM EDT", pcls_fix: "198.0", s: "0", t: "TSLA"},
    high: %Ticker.Quote{c: "+1.00", c_fix: "1.00", ccol: "chg", cp: "0.50",
        cp_fix: "0.50", e: "NASDAQ", id: "12607212", l: "200.00", l_cur: "200.00",
        l_fix: "200.00", lt: "Oct 21, 11:48AM EDT", lt_dts: "2016-10-21T11:48:10Z",
        ltt: "11:48AM EDT", pcls_fix: "198.0", s: "0", t: "TSLA"},
    low: %Ticker.Quote{c: "+1.00", c_fix: "1.00", ccol: "chg", cp: "0.50",
        cp_fix: "0.50", e: "NASDAQ", id: "12607212", l: "197.00", l_cur: "197.00",
        l_fix: "197.00", lt: "Oct 21, 11:48AM EDT", lt_dts: "2016-10-21T11:48:15Z",
        ltt: "11:48AM EDT", pcls_fix: "198.0", s: "0", t: "TSLA"},
    close: %Ticker.Quote{c: "+1.00", c_fix: "1.00", ccol: "chg", cp: "0.50",
        cp_fix: "0.50", e: "NASDAQ", id: "12607212", l: "199.00", l_cur: "199.00",
        l_fix: "199.00", lt: "Oct 21, 11:48AM EDT", lt_dts: "2016-10-21T11:48:20Z",
        ltt: "11:48AM EDT", pcls_fix: "198.0", s: "0", t: "TSLA"}
  }

  def notify_frame_test_callback(frame) do
    assert frame == @frame
  end


  #####
  # Notify Frame Client Interface

  test "init" do
    Ticker.Notify.Frame.start_link
    notify_frame_pid = Process.whereis(Ticker.Notify.Frame)
    assert is_pid(notify_frame_pid)
  end

  test "notify frame interface" do
    {:ok, _} = Ticker.Notify.Frame.start_link
    assert Ticker.Notify.Frame.notify(@frame) == :ok
  end


  #####
  # Notify Frame Server Interface

  test "notify frame" do
    Application.put_env(:ticker, :frame_notify, [notify_module: Ticker.Notify.Frame.Test, notify_fn: :notify_frame_test_callback], [persistent: true])
    state = %{}
    {:noreply, finalstate} = Ticker.Notify.Frame.handle_cast({:notify, @frame}, state)
    assert finalstate == state
  end

  test "notify frame -- no module configured" do
    Application.put_env(:ticker, :frame_notify, [notify_module: nil, notify_fn: :notify_frame_test_callback], [persistent: true])
    state = %{}
    {:noreply, finalstate} = Ticker.Notify.Frame.handle_cast({:notify, @frame}, state)
    assert finalstate == state
  end

  test "notify frame -- no callback configured" do
    Application.put_env(:ticker, :frame_notify, [notify_module: Ticker.Notify.Frame.Test, notify_fn: :nil], [persistent: true])
    state = %{}
    {:noreply, finalstate} = Ticker.Notify.Frame.handle_cast({:notify, @frame}, state)
    assert finalstate == state
  end

end