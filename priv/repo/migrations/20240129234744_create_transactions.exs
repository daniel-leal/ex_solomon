defmodule ExSolomon.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :description, :string
      add :amount, :integer
      add :is_fixed, :boolean, default: false, null: false
      add :is_revenue, :boolean, default: false, null: false
      add :recurring_day, :integer
      add :date, :date
      add :kind, :string
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :category_id, references(:categories, on_delete: :nothing, type: :binary_id)
      add :credit_card_id, references(:credit_cards, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:transactions, [:user_id])
    create index(:transactions, [:category_id])
    create index(:transactions, [:credit_card_id])
  end
end
