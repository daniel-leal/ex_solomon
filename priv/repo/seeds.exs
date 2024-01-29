# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ExSolomon.Repo.insert!(%ExSolomon.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias ExSolomon.Transactions.Schemas.Category

# Insert categories
categories = [
  %Category{description: "Food"},
  %Category{description: "Transportation"},
  %Category{description: "Entertainment"},
  %Category{description: "Health"},
  %Category{description: "Shopping"},
  %Category{description: "Travel"},
  %Category{description: "Education"},
  %Category{description: "Gifts"},
  %Category{description: "Other"}
]

Enum.each(categories, fn category ->
  ExSolomon.Repo.insert!(category)
end)
