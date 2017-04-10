defmodule Setter do
  defmacro bind_name(string) do
    quote do
      # name = unquote(string)
      var!(name) = unquote(string) # rebinds `name` in the calling scope
    end
  end
end
