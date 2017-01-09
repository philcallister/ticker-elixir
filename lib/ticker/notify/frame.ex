require Logger

defmodule Ticker.Notify.Frame do
  use GenServer

  ## Client API

  def start_link do
    Logger.info("Starting Frame Notification...")
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def notify(frame) do
    GenServer.cast(__MODULE__, {:notify, frame})
  end


  ## Server callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_cast({:notify, frame}, state) do
    frame_conf = Application.get_env(:ticker, :frame_notify)
    case frame_conf[:notify_module] do
      nil -> :empty
      :none -> :empty
      _ ->
        case frame_conf[:notify_fn] do
          nil -> :empty
          :none -> :empty
          _ -> apply(frame_conf[:notify_module], frame_conf[:notify_fn], [frame])
        end
    end
    {:noreply,  state}
  end

end
