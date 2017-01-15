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

  def is_a_quote?(%Ticker.Quote{}), do: true
  def is_a_quote?(_), do: false

  def as_type(ticker_quote, type \\ :string) do
    type_fn = case type do
      :string -> fn(value, sign) -> as_string(value, sign) end
      _       -> fn(value, _) -> as_float(value) end
    end
    %Ticker.Quote{
        id:       ticker_quote.id,
        t:        ticker_quote.t,
        e:        ticker_quote.e,
        l:        type_fn.(ticker_quote.l, false),
        l_fix:    type_fn.(ticker_quote.l_fix, false),
        l_cur:    type_fn.(ticker_quote.l_cur, false),
        s:        ticker_quote.s,
        ltt:      ticker_quote.ltt,
        lt:       ticker_quote.lt,
        lt_dts:   ticker_quote.lt_dts,
        c:        type_fn.(ticker_quote.c, true),
        c_fix:    type_fn.(ticker_quote.c_fix, false),
        cp:       type_fn.(ticker_quote.cp, false),
        cp_fix:   type_fn.(ticker_quote.cp_fix, false),
        ccol:     ticker_quote.ccol,
        pcls_fix: type_fn.(ticker_quote.pcls_fix, false)
    }
  end

  defp as_string(value, sign) do
    pre = case sign do
      true when value > 0 -> "+"
      _ -> nil
    end
    ~s(#{pre}#{Float.to_string(value, decimals: 2)})
  end

  defp as_float(value) do
    String.to_float(value)
  end

end
