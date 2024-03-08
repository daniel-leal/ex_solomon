alias ExSolomon.Transactions.Schemas.Category

Insert categories
categories = [
  %Category{description: "Alimentação"},
  %Category{description: "Moradia"},
  %Category{description: "Transporte"},
  %Category{description: "Lazer"},
  %Category{description: "Saúde"},
  %Category{description: "Shopping"},
  %Category{description: "Viagem"},
  %Category{description: "Educação"},
  %Category{description: "Presentes"},
  %Category{description: "Outros"}
]

Enum.each(categories, fn category ->
  ExSolomon.Repo.insert!(category)
end)
