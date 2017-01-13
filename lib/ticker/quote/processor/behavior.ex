defmodule Ticker.Quote.Processor.Behaviour do
  @moduledoc """
  Quote Processor Behaviour

  This Module defines a behaviour for processing quotes
  """

  @doc """
  process the given quotes
  """
  @callback process(symbols :: list) :: {:ok, [%Ticker.Quote{}]} | {:error, String.t}

  @doc """
  build historical for given symbols
  """
  @callback historical(symbols :: list) :: {:ok, [%Ticker.Quote{}]} | {:error, String.t}

end
