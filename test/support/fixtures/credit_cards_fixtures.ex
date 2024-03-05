defmodule ExSolomon.CreditCardsFixtures do
  import Support.Factory

  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExSolomon.CreditCards` context.
  """

  @doc """
  Generate a credit_card.
  """
  def credit_card_fixture() do
    insert(:credit_card)
  end
end
