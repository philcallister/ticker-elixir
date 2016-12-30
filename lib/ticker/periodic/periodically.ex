require Logger

# TODO: Create a behavior for which worker function needs to implement
defmodule Ticker.Periodic.Periodically do
  use GenServer

  def start_link(work_fn, interval, startup \\ true) do
    Logger.info("Starting Periodic Work Scheduler...")
    GenServer.start_link(__MODULE__, {:ok, work_fn, interval, startup}, name: __MODULE__)
  end

  def init({:ok, work_fn, interval, startup}) do
    if interval > 0, do: schedule_work(work_fn, interval, startup)
    {:ok, nil}
  end

  def handle_info({:work, work_fn, interval, startup}, state) do
    work_fn.(startup)
    schedule_work(work_fn, interval, false) # Reschedule work
    {:noreply, state}
  end

  defp schedule_work(work_fn, interval, startup) when startup do
    Process.send_after(self(), {:work, work_fn, interval, true}, 0)
  end

  defp schedule_work(work_fn, interval, _) do
    Process.send_after(self(), {:work, work_fn, interval, false}, interval)
  end

end
