defmodule ExSolomon.Transactions.Schemas.CreditCard do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "credit_cards" do
    field :name, :string
    field :limit, Money.Ecto.Amount.Type
    field :invoice_start_day, :integer
    field :user_id, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(credit_card, attrs) do
    credit_card
    |> cast(attrs, [:name, :limit, :invoice_start_day])
    |> validate_required([:name, :limit, :invoice_start_day])
  end
end
