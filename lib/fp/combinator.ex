defmodule Fp.Combinator do
  import Fp.Foundation

  @doc """
  ## Example

  iex> (&id/1) <<< 123
  123
  """
  @spec id(a) :: a when a: term
  def id(x), do: x

  @doc """
  ## Example

  iex> banana = (&const/2) <<< :banana
  iex> banana <<< 123
  :banana
  """
  @spec const(a, term) :: a when a: term
  def const(x, _), do: x

  @doc """
  ## Example

  iex> plus1 = (&+/2) <<< 1
  iex> inspect_after_plus1 = (&compose/2) <<< (&inspect/1) <<< plus1
  iex> inspect_after_plus1 <<< 123
  "124"
  """
  @spec compose((b -> c), (a -> b)) :: (a -> c) when a: term, b: term, c: term
  def compose(g, h), do: fn x -> g <<< (h <<< x) end

  @doc """
  ## Example

  iex> plus1 = (&+/2) <<< 1
  iex> inspect = &inspect/1
  iex> add_label = (&<>/2) <<< "total: "
  iex> show_total = add_label <|> inspect <|> plus1
  iex> show_total <<< 123
  "total: 124"
  """
  @spec (b -> c) <|> (a -> b) :: (a -> c) when a: term, b: term, c: term
  def g <|> h, do: (&compose/2) <<< g <<< h
end
