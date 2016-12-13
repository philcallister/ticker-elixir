require Logger

defmodule Ticker.Symbol.TimeFrame do
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
    frame = Frame.quotes_to_frame(quotes)
    frame_key = process_frame(frame, state)
    {:noreply,  %{:name => state[:name], :interval => state[:interval], :frame_count => state[:frame_count], :next_intervals => state[:next_intervals], :frames => [], :frame_key => frame_key}}
  end

  def handle_cast({:rollup_frames, frames}, state) do
    current_frames = state[:frames] ++ frames
    {remaining_frames, frame_key} = cond do

      # Process only given frame count
      length(current_frames) >= state[:frame_count] ->
        {included, excluded} = Enum.split(current_frames, state[:frame_count])
        frame = Frame.frames_to_frame(included)
        frame_key_update = process_frame(frame, state)
        {excluded, frame_key_update}

      # Not enough frames to process
      true -> {current_frames, state[:frame_key]}
    end
    {:noreply,  %{:name => state[:name], :interval => state[:interval], :frame_count => state[:frame_count], :next_intervals => state[:next_intervals], :frames => remaining_frames, :frame_key => frame_key}}
  end

  defp ets_table_name(name, interval) do
    :"#{name}_#{interval}"
  end

  defp process_frame(frame, state) do
    IO.puts "***** FRAME: #{state[:name]} | INTERVAL: #{state[:interval]}"
    frame_key = state[:frame_key] + 1
    :ets.insert(ets_table_name(state[:name], state[:interval]), {frame_key, frame})
    if state[:next_intervals] do
      Enum.each(state[:next_intervals], fn(i) -> Ticker.Symbol.TimeFrame.rollup_frames(state[:name], i, [frame]) end)
    end
    frame_key
  end

end

defmodule Ticker.Symbol.TimeFrame.Supervisor do
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
      worker(Ticker.Symbol.TimeFrame, [])
    ]
    supervise(children, strategy: :simple_one_for_one)
  end

end
