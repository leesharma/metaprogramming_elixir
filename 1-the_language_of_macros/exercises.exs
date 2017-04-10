defmodule ControlFlow do
  @moduledoc """
  Define an unless macro without depending on Kernel.if/2 by using other
  constructs in Elixir for control flow.
  """

  defmacro unless(expression, do: block) do
    quote do
      case unquote(expression) do
        x when x in [false, nil]  -> unquote(block)
        _                         -> nil
      end
    end
  end
end

defmodule Meta do
  @moduledoc """
  Define a macro that returns a raw AST that you’ve written by hand, instead of
  using quote for code generation.
  """

  @doc """
  ## Examples

      iex> Meta.pseudoquote 1 + 1
      {:+, [], 1 + 1}

      iex> Meta.pseudoquote {:one, [1, 2, 3], %{foo: :bar}}
      {:{}, [], [:one, [1, 2, 3], {:%{}, [], [foo: :bar]}]}
  """
  defmacro pseudoquote({keyword, context, args}) when is_list(args) do
    expanded_args = for arg <- args, do: Meta.pseudoquote(arg)
    {:{}, [], [keyword, context, expanded_args]}
  end

  defmacro pseudoquote({keyword, context, arg}) do
    {:{}, [], [keyword, context, arg]}
  end

  defmacro pseudoquote(base_expression) do
    base_expression
  end
end
