require Logger

defmodule Ticker.Periodically do
  use GenServer

  def start_link(work_fn, interval, on_start \\ true) do
    Logger.info("Starting Periodic Work Scheduler...")
    GenServer.start_link(__MODULE__, {:ok, work_fn, interval, on_start}, name: __MODULE__)
  end

  def init({:ok, work_fn, interval, on_start}) do
    schedule_work(work_fn, interval, on_start)
    {:ok, nil}
  end

  def handle_info({:work, work_fn, interval}, state) do
    work_fn.()
    schedule_work(work_fn, interval, false) # Reschedule work
    {:noreply, state}
  end

  defp schedule_work(work_fn, interval, on_start) when on_start do
    Process.send_after(self(), {:work, work_fn, interval}, 0)
  end

  defp schedule_work(work_fn, interval, _) do
    Process.send_after(self(), {:work, work_fn, interval}, interval)
  end

end
