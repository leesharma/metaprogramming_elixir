defmodule HexClient.Package do
  HTTPotion.start

  # TODO: get the rest of the pages
  # TODO: extract into functions?
  # TODO: include package?

  "https://hex.pm/api/packages"
  |> HTTPotion.get(headers: ["User-Agent": "Elixir"])
  |> Map.get(:body)
  |> Poison.decode!
  |> Enum.map(fn %{"name" => name} = package ->
    def unquote(String.to_atom name)(), do: unquote(Macro.escape(package))
  end)
end
