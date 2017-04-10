defmodule Math do
  @moduledoc """
  Example from Chapter 1.1: "let’s write a macro that can print the spoken form
  of an Elixir mathematical expression, such as 5 + 2, when calculating a
  result."
  """

  @vsn 0.1

  @doc """
  Prints the spoken form of an Elixir mathematical expresssion.

  Takes a mathematical expression, such as `5 + 2` or `8 * 3`, prints the spoken
  expression to the console (ex. "5 times 2 is 10"), and returns the result.
  """

  @spec say(tuple) :: number

  # quote do: 5 + 2
  # => {:+, [context: Elixir, import Kernel], [5, 2]}
  defmacro say({:+, _, [lhs, rhs]}) do
    quote do
      lhs = unquote(lhs)
      rhs = unquote(rhs)
      result = lhs + rhs
      IO.puts "#{lhs} plus #{rhs} is #{result}"
      result
    end
  end

  # quote do: 8 * 3
  # => {:*, [context: Elixir, import: Kernel], [8, 3]}
  defmacro say({:*, _, [lhs, rhs]}) do
    quote do
      lhs = unquote(lhs)
      rhs = unquote(rhs)
      result = lhs * rhs
      IO.puts "#{lhs} times #{rhs} is #{result}"
      result
    end
  end
end
