defmodule ExSolomon.Repo.Migrations.CreateCreditCards do
  use Ecto.Migration

  def change do
    create table(:credit_cards, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :limit, :integer
      add :invoice_start_day, :integer
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:credit_cards, [:user_id])
  end
end
