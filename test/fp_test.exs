defmodule FpTest do
  use ExUnit.Case
  use PropCheck
  use Fp
  doctest Fp
  doctest Fp.Foundation
  doctest Fp.Combinator
  doctest Fp.Class.Functor

  @numtests 300

  defp scalar do
    m = PropCheck.BasicTypes

    m.__info__(:functions)
    |> Stream.filter(fn {_, x} -> x == 0 end)
    |> Enum.map(fn {f, _} ->
      fn -> apply(m, f, []) end
    end)
    |> oneof
  end

  defp either(a, b) do
    let [
      tag <- oneof([:error, :ok]),
      lhs <- a,
      rhs <- b
    ] do
      case tag do
        :error -> {tag, lhs}
        :ok -> {tag, rhs}
      end
    end
  end

  defp fmappable(a, b) do
    weighted_union([
      {1, either(a, b)},
      {1, list(a)}
    ])
  end

  describe "Functor Laws" do
    property "identity" do
      quickcheck(
        forall [
          a0 <- scalar(),
          b0 <- scalar()
        ] do
          a = a0.()
          b = b0.()

          forall [x <- fmappable(a, b)] do
            (&fmap/2) <<< (&id/1) <<< x == x
          end
        end,
        numtests: @numtests
      )
    end

    property "composition" do
      quickcheck(
        forall [
          a0 <- scalar(),
          b0 <- scalar(),
          c0 <- scalar(),
          d0 <- scalar()
        ] do
          a = a0.()
          b = b0.()
          c = c0.()
          d = d0.()

          forall [
            x <- fmappable(a, b),
            h <- function([b], c),
            g <- function([c], d)
          ] do
            l = (&fmap/2) <<< (g <|> h)
            r = (&fmap/2) <<< g <|> ((&fmap/2) <<< h)
            l <<< x == r <<< x
          end
        end,
        numtests: @numtests
      )
    end
  end
end
