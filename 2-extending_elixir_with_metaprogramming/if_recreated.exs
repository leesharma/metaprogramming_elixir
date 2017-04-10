defmodule ControlFlow do
  # This could also be implemented like elixir's `if` with private helper funcs
  defmodule WorkingVersion do
    defmacro my_if(expr, do: if_block) do
      quote do
        ControlFlow.WorkingVersion.my_if unquote(expr) do
          unquote(if_block)
        else
          nil
        end
      end
    end

    defmacro my_if(expr, do: if_block, else: else_block) do
      quote do
        case unquote(expr) do
          result when result in [false, nil]  -> unquote(else_block)
          _                                   -> unquote(if_block)
        end
      end
    end
  end


  defmodule BookVersion do
    defmacro my_if(expr, do: if_block) do
      IO.puts "no else_block provided"

      ControlFlow.BookVersion.my_if(expr, do: if_block, else: nil)
    end

    # Same as WorkingVersion (plus puts statements)
    defmacro my_if(expr, do: if_block, else: else_block) do
      IO.puts "else_block provided (outside of `quote`)"
      quote bind_quoted: [expr: expr, if_block: if_block, else_block: else_block] do
        IO.puts "else_block provided (in `quote`): #{inspect else_block}"
        IO.puts "Expr: #{inspect expr}"
        IO.puts "If block: #{inspect if_block}"

        case expr do
          result when result in [false, nil]  -> else_block
          _                                   -> if_block
        end
      end
    end
  end
end
