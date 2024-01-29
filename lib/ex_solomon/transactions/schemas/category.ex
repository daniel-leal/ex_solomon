defmodule ExSolomon.Transactions.Schemas.Category do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "categories" do
    field :description, :string

    timestamps(type: :utc_datetime)
  end
end
