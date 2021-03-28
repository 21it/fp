defmodule Fp do
  @moduledoc """
  Enables functional programming in Elixir.

  ## Example

  iex> use Fp
  """

  defmacro __using__(_) do
    quote do
      import Fp.Foundation
      import Fp.Combinator
      import Fp.Class.Functor
    end
  end
end
