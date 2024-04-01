defmodule ExSolomon.CreditCards.Schemas.CreditCard do
  use Ecto.Schema

  import Ecto.Changeset

  alias ExSolomon.CreditCards.Schemas.CreditCard
  alias ExSolomon.DateUtils

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "credit_cards" do
    field :name, :string
    field :limit, Money.Ecto.Amount.Type
    field :invoice_start_day, :integer
    field :user_id, :binary_id

    belongs_to :user, ExSolomon.Accounts.Schemas.User, define_field: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(credit_card, attrs) do
    credit_card
    |> cast(attrs, [:name, :limit, :invoice_start_day, :user_id])
    |> validate_required([:name, :limit, :invoice_start_day, :user_id])
    |> validate_number(:invoice_start_day, less_than: 32)
  end

  @doc """
  Get current invoice period based on start_day.

  ## Examples

      iex> ExSolomon.CreditCards.Schemas.CreditCard.get_current_invoice(%CreditCard{invoice_start_day: 7})
      {~D[2024-02-07], ~D[2024-03-06]}
  """
  def get_current_invoice(%CreditCard{invoice_start_day: day}) do
    current_date = DateUtils.utc_now()

    if current_date.day < day do
      start_day =
        current_date
        |> Timex.shift(months: -1)
        |> Timex.set(day: day)

      end_day = Timex.shift(start_day, months: 1, days: -1)
      {start_day, end_day}
    else
      start_day = Timex.set(current_date, day: day)
      end_day = Timex.shift(start_day, months: 1, days: -1)
      {start_day, end_day}
    end
  end
end
