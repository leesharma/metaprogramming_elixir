defmodule Mod do
  @moduledoc """
  Let’s see this in action by defining a definfo macro that prints a module’s
  information in a friendly format while showing what context the code is
  executing in.
  """

  defmacro definfo do
    IO.puts "In macro's context (#{__MODULE__})."

    quote do
      IO.puts "In caller's context (#{__MODULE__})."

      def friendly_info do
        IO.puts """
        My name is #{__MODULE__}
        My functions are #{inspect __info__(:functions)}
        """
      end
    end
  end
end

defmodule MyModule do
  require Mod
  Mod.definfo
end
