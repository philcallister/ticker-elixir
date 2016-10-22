defmodule Ticker.Quote do
  @derive [Poison.Encoder]
  defstruct [
    :id,
    :t,
    :e,
    :l,
    :l_fix,
    :l_cur,
    :s,
    :ltt,
    :lt,
    :lt_dts,
    :c,
    :c_fix,
    :cp,
    :cp_fix,
    :ccol,
    :pcls_fix
  ]
end
