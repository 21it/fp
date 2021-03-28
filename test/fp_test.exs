defmodule FpTest do
  use ExUnit.Case
  use Fp
  doctest Fp
  doctest Fp.Foundation
  doctest Fp.Combinator
  doctest Fp.Class.Functor
end
