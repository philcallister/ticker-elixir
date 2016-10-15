defmodule Ticker.Quote do
  @derive [Poison.Encoder]
  defstruct [
    :id,       #
    :t,        # Symbol Name
    :e,        #
    :l,        #
    :l_fix,    #
    :l_cur,    #
    :s,        #
    :ltt,      #
    :lt,       #
    :lt_dts,   #
    :c,        #
    :c_fix,    #
    :cp,       #
    :cp_fix,   #
    :ccol,     #
    :pcls_fix, #
    :el,       #
    :el_fix,   #
    :el_cur,   #
    :elt,      #
    :ec,       #
    :ec_fix,   #
    :ecp,      #
    :ecp_fix,  #
    :eccol,    #
    :div,      #
    :yld       #
  ]
end
