defmodule I18n do
  use Translator

  locale "en",
    flash: [
      hello: "Hello %{first} %{last}!",
      bye: "Bye, %{name}!"
    ],
    users: [
      title: [
        "1": "User"
        other: "Users"
      ],
    ]

  locale "fr",
    flash: [
      hello: "Salut %{first} %{last}!",
      bye: "Au revoir, %{name}!"
    ],
    users: [
      title: [
        "1": "Utilisateurs",
        other: "Utilisateurs",
      ]
    ]
end

# IO.puts I18n.t("en", "flash.hello", first: "Chris", last: "McCord")
# IO.puts I18n.t("fr", "flash.hello", first: "Chris", last: "McCord")
# IO.puts I18n.t("fr", "users.title")
