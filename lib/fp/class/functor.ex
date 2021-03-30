import Fp.Foundation
functor = Fp.Class.Functor.Protocol

defprotocol functor do
  @type t(a) :: t(a)
  @spec ffmap(t(a), (a -> b)) :: t(b)
        when a: term, b: term
  def ffmap(x, f)
end

defimpl functor, for: Tuple do
  def ffmap({:error, e}, _), do: {:error, e}
  def ffmap({:ok, x}, f), do: {:ok, f <<< x}
end

defimpl functor, for: List do
  def ffmap(x, f), do: (&:lists.map/2) <<< f <<< x
end

defimpl functor, for: Map do
  def ffmap(x, f) do
    fun = fn k, v, acc ->
      (&:maps.put/3) <<< k <<< (f <<< v) <<< acc
    end

    (&:maps.fold/3) <<< fun <<< %{} <<< x
  end
end

defmodule Fp.Class.Functor do
  require Fp.Class.Functor.Protocol, as: Functor
  import Fp.Class.Functor.Protocol

  @spec fmap((a -> b), Functor.t(a)) :: Functor.t(b)
        when a: term, b: term
  def fmap(f, x), do: (&ffmap/2) <<< x <<< f
  def f <~ x, do: (&ffmap/2) <<< x <<< f
  def x ~> f, do: (&ffmap/2) <<< x <<< f
end
