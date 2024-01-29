defmodule ExSolomon.TransactionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExSolomon.Transactions` context.
  """

  @doc """
  Generate a credit_card.
  """
  def credit_card_fixture(attrs \\ %{}) do
    {:ok, credit_card} =
      attrs
      |> Enum.into(%{
        invoice_start_day: 42,
        limit: Money.new(4200),
        name: "some name"
      })
      |> ExSolomon.Transactions.create_credit_card()

    credit_card
  end
end
