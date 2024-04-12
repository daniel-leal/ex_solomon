defmodule ExSolomon.Transactions.Schemas.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  alias ExSolomon.Transactions.Types.TransactionTypes

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "transactions" do
    field :date, :date
    field :description, :string
    field :kind, :string
    field :amount, Money.Ecto.Amount.Type
    field :is_fixed, :boolean, default: false
    field :is_revenue, :boolean, default: false
    field :recurring_day, :integer, default: nil
    field :user_id, :binary_id
    field :category_id, :binary_id
    field :credit_card_id, :binary_id

    belongs_to :user, ExSolomon.Accounts.Schemas.User, define_field: false
    belongs_to :category, ExSolomon.Transactions.Schemas.Category, define_field: false
    belongs_to :credit_card, ExSolomon.CreditCards.Schemas.CreditCard, define_field: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [
      :date,
      :description,
      :kind,
      :amount,
      :is_fixed,
      :is_revenue,
      :recurring_day,
      :user_id,
      :category_id,
      :credit_card_id
    ])
    |> validate_required([
      :description,
      :kind,
      :amount,
      :is_fixed,
      :is_revenue,
      :user_id,
      :category_id
    ])
    |> validate_inclusion(:kind, Enum.map(TransactionTypes.kinds(), & &1.value))
    |> validate_recurrency()
    |> validate_number(:recurring_day, less_than: 29)
    |> validate_credit_card_required()
  end

  defp validate_recurrency(changeset) do
    is_fixed = get_field(changeset, :is_fixed)
    date = get_field(changeset, :date)
    recurring_day = get_field(changeset, :recurring_day)

    case {is_fixed, date, recurring_day} do
      {false, nil, _} ->
        add_error(changeset, :date, "campo obrigatório")

      {true, _, nil} ->
        add_error(changeset, :recurring_day, "campo obrigatório")

      {false, _, _} ->
        put_change(changeset, :recurring_day, nil)

      {true, _, _} ->
        put_change(changeset, :date, nil)

      _ ->
        changeset
    end
  end

  defp validate_credit_card_required(changeset) do
    kind = get_field(changeset, :kind)
    credit_card_id = get_field(changeset, :credit_card_id)

    case {kind, credit_card_id} do
      {"credit", nil} ->
        add_error(changeset, :credit_card_id, "campo obrigatório")

      _ ->
        changeset
    end
  end
end
