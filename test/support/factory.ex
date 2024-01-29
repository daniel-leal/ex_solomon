defmodule Support.Factory do
  use ExMachina.Ecto, repo: ExSolomon.Repo

  alias ExSolomon.Transactions.Schemas.Category

  def category_factory do
    %Category{
      description: sequence(:category, ["Food", "Transport", "Entertainment"])
    }
  end
end
