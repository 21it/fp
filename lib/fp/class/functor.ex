import Fp.Foundation

defprotocol Functor do
  @type t(a) :: t(a)
  @spec ffmap(t(a), (a -> b)) :: t(b) when a: term, b: term
  def ffmap(x, f)
end

defmodule Fp.Class.Functor do
  import Functor
  @spec fmap((a -> b), Functor.t(a)) :: Functor.t(b) when a: term, b: term
  def fmap(f, x), do: (&ffmap/2) <<< x <<< f
  def f <~ x, do: (&ffmap/2) <<< x <<< f
  def x ~> f, do: (&ffmap/2) <<< x <<< f
end

defimpl Functor, for: Tuple do
  def ffmap({:error, e}, _), do: {:error, e}
  def ffmap({:ok, x}, f), do: {:ok, f <<< x}
end

defimpl Functor, for: List do
  def ffmap(x, f), do: (&:lists.map/2) <<< f <<< x
end
