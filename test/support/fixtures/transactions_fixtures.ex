defmodule ExSolomon.TransactionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExSolomon.Transactions` context.
  """

  @doc """
  Generate a transaction.
  """
  def transaction_fixture(attrs \\ %{}) do
    {:ok, transaction} =
      attrs
      |> Enum.into(%{
        amount: 42,
        date: ~D[2024-01-28],
        description: "some description",
        is_fixed: true,
        is_revenue: true,
        kind: "some kind",
        recurring_day: 5
      })
      |> ExSolomon.Transactions.create_transaction()

    transaction
  end
end
