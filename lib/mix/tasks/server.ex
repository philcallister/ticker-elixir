require Logger

defmodule Mix.Tasks.Ticker.Server do

  use Mix.Task

  @shortdoc "Start Ticker Server"

  @moduledoc """
  Start Ticker Server.

  ## Command line options
  This task accepts the same command-line arguments as `run`.
  For additional information, refer to the documentation for
  `Mix.Tasks.Run`.
  """
  def run(args) do
    Logger.info("Starting Ticker Server...")
    Mix.Task.run "run", run_args() ++ args
  end

  defp run_args do
    if iex_running?(), do: [], else: ["--no-halt"]
  end

  defp iex_running? do
    Code.ensure_loaded?(IEx) and IEx.started?
  end

end
