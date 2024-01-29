defmodule ExSolomon.Transactions do
  @moduledoc """
  The Transactions context.
  """

  # Credit Cards
  alias ExSolomon.Transactions.UseCases.{
    ChangeCreditCard,
    CreateCreditCard,
    DeleteCreditCard,
    UpdateCreditCard
  }

  defdelegate change_credit_card(credit_card, attrs \\ %{}),
    to: ChangeCreditCard,
    as: :execute

  defdelegate create_credit_card(attrs \\ %{}), to: CreateCreditCard, as: :execute

  defdelegate delete_credit_card(credit_card),
    to: DeleteCreditCard,
    as: :execute

  defdelegate update_credit_card(credit_card, attrs),
    to: UpdateCreditCard,
    as: :execute
end
