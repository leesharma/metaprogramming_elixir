##
# FURTHER EXPLORATION
# ===================
#
# On your own, explore ways you can enhance your `Assertion` test framework and
# define new macro constructs. Here are a few basic experiments to get you
# started:
#
#   * [_] Implement `assert` for every operator in elixir
#   * [_] Add Boolean assertions, such as `assert true`
#   * [_] Implement a `refute` macro for refutions
#
# And some that are more advanced:
#
#   * [_] Run test cases in parallel within `Assertion.test.run/2` via spawned
#         processes
#
#   * [_] Add reports for the module. Include pass/fail counts and execution
#         time
##

defmodule Assertion do
  defmacro __using__(_options) do
    quote do
      import unquote(__MODULE__) # Assertion
      Module.register_attribute __MODULE__, :tests, accumulate: true

      @before_compile unquote(__MODULE__) # Assertion
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def run, do: Assertion.Test.run(@tests, __MODULE__) # TestModule
    end
  end

  defmacro test(description, do: test_block) do
    test_func = String.to_atom(description)
    quote do
      @tests {unquote(test_func), unquote(description)}
      def unquote(test_func)(), do: unquote(test_block)
    end
  end

  # {:==, [context: Elixir, import: Kernel], [5, 5]}
  defmacro assert({operator, _, [lhs, rhs]}) do
    quote bind_quoted: [operator: operator, lhs: lhs, rhs: rhs] do
      Assertion.Test.assert(operator, lhs, rhs)
    end
  end
end

defmodule Assertion.Test do
  def run(tests, module) do
    for {test_func, description} <- tests do
      case apply(module, test_func, []) do # TestModule
        :ok             -> IO.write "."
        {:fail, reason} -> IO.puts """

          ===============================================
          FAILURE: #{description}
          ===============================================
          #{reason}
          """
      end
    end
  end

  def assert(:==, lhs, rhs) when lhs == rhs, do: :ok
  def assert(:==, lhs, rhs) do
    {:fail, """
      Expected:       #{lhs}
      to be equal to: #{rhs}
      """
    }
  end

  def assert(:>, lhs, rhs) when lhs > rhs, do: :ok
  def assert(:>, lhs, rhs) do
    {:fail, """
      Expected:           #{lhs}
      to be greater than: #{rhs}
      """
    }
  end

  def assert(operator, lhs, rhs) do
    test_result = apply(Kernel, operator, [lhs, rhs])
    if test_result do
      :ok
    else
      {:fail, """
        LHS: #{lhs}
        RHS: #{rhs}
        """
      }
    end
  end
end

defmodule AllOperatorsTest do
  use Assertion

  test "numerical operators" do
    assert 1 == 1
    assert 2 > 1
    assert 1 < 2
    assert 1 >= 1
    assert 1 <= 1
  end

  test "non-numerical operators" do
    assert 1 == 3
    # assert is_bitstring("cat")
    # assert 1 in 0..5
    # assert is_atom(true)
    # assert String.empty?("")
  end
end

# defmodule BooleanTest do
#   use Assertion
#
#   test "true is true" do
#     assert true
#     # assert false
#   end
# end

# defmodule RefuteTest do
#   use Assertion
#
#   test "refute is the opposite of assert" do
#     refute 1 == 2
#     refute 1 > 3
#   end
# end

# defmodule ParallelTest do
# end

# defmodule ReportsTest do
# end
