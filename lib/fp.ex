defmodule Fp do
  @moduledoc """
  Enables functional programming in Elixir.

  ## Examples

      iex> import Fp
  """

  @type thunk(a) :: (() -> a)
  @type function(a) :: (... -> a)
  @type curried_function(a) :: (term -> curried_function(a) | a)

  @doc """
  Applies a function with arity more than zero to given argument.
  Left assotiative infix synonym `<<<` is provided for convenience
  to avoid nested brackets in case of multiple application.

  ## Examples

      iex> is_name? = apply1(&Regex.match?/2, ~r/^[A-Z][a-z]*$/)
      iex> apply1(is_name?, "Alice")
      true
      iex> apply1(is_name?, "hello")
      false
      iex> apply1(apply1(&div/2, 10), 2)
      5

  """
  @spec apply1(thunk(a), term) :: no_return when a: term
  @spec apply1(function(a), term) :: curried_function(a) | a when a: term
  def apply1(f, x), do: curry(f).(x)

  @doc """
  Applies a function with arity more than zero to given argument.
  Left assotiative infix synonym `<<<` is provided for convenience
  to avoid nested brackets in case of multiple application.

  ## Examples

      iex> is_name? = (&Regex.match?/2) <<< ~r/^[A-Z][a-z]*$/
      iex> is_name? <<< "Alice"
      true
      iex> is_name? <<< "hello"
      false
      iex> (&div/2) <<< 10 <<< 2
      5

  """
  @spec thunk(a) <<< term :: no_return when a: term
  @spec function(a) <<< term :: curried_function(a) | a when a: term
  def f <<< x, do: apply1(f, x)

  @spec curry(thunk(a)) :: thunk(a) when a: term
  @spec curry(function(a)) :: curried_function(a) when a: term
  def curry(f) do
    case Function.info(f, :arity) do
      {:arity, n} when n in [0, 1] -> f
      {:arity, n} -> curry_(f, n, [])
    end
  end

  defp curry_(f, 0, xs), do: apply(f, Enum.reverse(xs))
  defp curry_(f, n, xs), do: &curry_(f, n - 1, [&1 | xs])
end
