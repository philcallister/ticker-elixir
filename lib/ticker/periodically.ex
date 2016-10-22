require Logger

defmodule Ticker.Periodically do
  use GenServer

  def start_link do
    Logger.info("Starting Periodic Work Scheduler...")
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    schedule_work # Schedule work to be performed at some point
    {:ok, %{}}
  end

  def handle_info(:work, state) do
    Ticker.Quote.Processor.quotes
    schedule_work() # Reschedule work
    {:noreply, state}
  end

  defp schedule_work do
    Process.send_after(self(), :work, 60_000) # 1 Minute
  end

end
