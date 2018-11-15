defmodule HTS221.Calibration do
  import Bitwise

  defstruct [
    :t0_degc_x8,
    :t1_degc_x8,
    :t0_msb,
    :t0_out,
    :t1_msb,
    :t1_out,
    :h0_rh_x2,
    :h0_t0_out,
    :h1_rh_x2,
    :h1_t0_out
  ]

  def from_binary(
        <<h0_rh_x2, h1_rh_x2, t0_degc_x8, t1_degc_x8, _, _::size(4), t1_msb::size(2),
          t0_msb::size(2), h0_t0_out::signed-little-integer-size(2)-unit(8), _::binary-size(2),
          h1_t0_out::signed-little-integer-size(2)-unit(8),
          t0_out::signed-little-integer-size(2)-unit(8),
          t1_out::signed-little-integer-size(2)-unit(8)>>
      ) do
    calibration = %__MODULE__{
      t0_degc_x8: t0_degc_x8,
      t1_degc_x8: t1_degc_x8,
      t0_msb: t0_msb,
      t0_out: t0_out,
      t1_msb: t1_msb,
      t1_out: t1_out,
      h0_rh_x2: h0_rh_x2,
      h0_t0_out: h0_t0_out,
      h1_rh_x2: h1_rh_x2,
      h1_t0_out: h1_t0_out
    }

    {:ok, calibration}
  end

  def from_binary(_), do: {:error, :invalid_binary}

  def t0(%__MODULE__{t0_msb: t0_msb, t0_degc_x8: t0_degc_x8}) do
    ((t0_msb <<< 8) + t0_degc_x8) / 8
  end

  def t1(%__MODULE__{t1_msb: t1_msb, t1_degc_x8: t1_degc_x8}) do
    ((t1_msb <<< 8) + t1_degc_x8) / 8
  end

  def h0(%__MODULE__{h0_rh_x2: h0_rh_x2}) do
    h0_rh_x2 / 2
  end

  def h1(%__MODULE__{h1_rh_x2: h1_rh_x2}) do
    h1_rh_x2 / 2
  end
end