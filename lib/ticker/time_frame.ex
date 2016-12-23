require Logger

defmodule Ticker.TimeFrame do
  use GenServer

  alias Ticker.Frame

  def start_link(name, {interval, frame_count, next_intervals}) do
    Logger.info("Starting Frame: #{interval}")
    GenServer.start_link(__MODULE__, {:ok, {name, interval, frame_count, next_intervals}}, name: via_tuple({name, interval}))
  end

  def rollup_quotes(name, quotes) do
    GenServer.cast(via_tuple({name, 1}), {:rollup_quotes, quotes})
  end

  def rollup_frames(name, interval, frames) do
    GenServer.cast(via_tuple({name, interval}), {:rollup_frames, frames})
  end

  # TODO: Create a module that exposes a facade-like interface to all externally
  # facing functionallity. This should be in that interface
  def get_frames(name, interval) do
    GenServer.call(via_tuple({name, interval}), :get_frames)
  end

  defp via_tuple({name, interval}) do
    {:via, :gproc, {:n, :l, {__MODULE__, name, interval}}}
  end


  ## Server callbacks

  def init({:ok, {name, interval, frame_count, next_intervals}}) do
    table_name = ets_table_name(name, interval)
    :ets.new(table_name, [:set, :protected, :named_table])
    {:ok, %{:name => name, :interval => interval, :frame_count => frame_count, :next_intervals => next_intervals, :frames => [], :frame_key => 0}}
  end

  def handle_cast({:rollup_quotes, quotes}, state) do
    frame = Frame.quotes_to_frame(state[:name], state[:interval], quotes)
    frame_key = state[:frame_key] + 1
    frame
      |> process(frame_key, state)
      |> notify
    {:noreply,  %{:name => state[:name], :interval => state[:interval], :frame_count => state[:frame_count], :next_intervals => state[:next_intervals], :frames => [], :frame_key => frame_key}}
  end

  def handle_cast({:rollup_frames, frames}, state) do
    current_frames = state[:frames] ++ frames
    {remaining_frames, frame_key} = cond do

      # Process only given frame count
      length(current_frames) >= state[:frame_count] ->
        {included, excluded} = Enum.split(current_frames, state[:frame_count])
        frame = Frame.frames_to_frame(state[:name], state[:interval], included)
        frame_key_update = state[:frame_key] + 1
        frame
          |> process(frame_key_update, state)
          |> notify
        {excluded, frame_key_update}

      # Not enough frames to process
      true -> {current_frames, state[:frame_key]}
    end
    {:noreply,  %{:name => state[:name], :interval => state[:interval], :frame_count => state[:frame_count], :next_intervals => state[:next_intervals], :frames => remaining_frames, :frame_key => frame_key}}
  end

  def handle_call(:get_frames, _from, state) do
    records = :ets.match_object(ets_table_name(state[:name], state[:interval]), {:"_", :"_"})
    frames = Enum.map(records, fn({_, frame}) -> frame end)
    {:reply, frames, state}
  end

  defp ets_table_name(name, interval) do
    :"#{name}_#{interval}"
  end

  defp process(frame, frame_key, state) do
    Logger.info "***** Symbol: #{state[:name]} | Interval: #{state[:interval]}"
    :ets.insert(ets_table_name(state[:name], state[:interval]), {frame_key, frame})
    if state[:next_intervals] do
      Enum.each(state[:next_intervals], fn(i) -> Ticker.TimeFrame.rollup_frames(state[:name], i, [frame]) end)
    end
    frame
  end

  defp notify(frame) do
    Ticker.Notify.Frame.notify(frame)
  end

end

defmodule Ticker.TimeFrame.Supervisor do
  use Supervisor

  @intervals [{1, :none, [2,5]}, {2, 2, nil}, {5, 5, [15]}, {15, 3, [30]}, {30, 2, [60]}, {60, 2, nil}]

  def start_link(name) do
    Logger.info("Starting Frame Supervisor: #{name}")
    {:ok, pid} = Supervisor.start_link(__MODULE__, {:ok}, name: via_tuple(name))
    Enum.each(@intervals, fn(interval) -> Supervisor.start_child(pid, [name, interval]) end)
    {:ok, pid}
  end

  defp via_tuple(name) do
    {:via, :gproc, {:n, :l, {__MODULE__, name}}}
  end


  ## Server callbacks

  def init({:ok}) do
    children = [
      worker(Ticker.TimeFrame, [])
    ]
    supervise(children, strategy: :simple_one_for_one)
  end

end
