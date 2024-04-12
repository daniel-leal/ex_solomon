defmodule ExSolomon.Transactions do
  @moduledoc """
  The Transactions context.
  """

  alias ExSolomon.Transactions.UseCases.{
    CalculateVariation,
    ChangeTransaction,
    CreateTransaction,
    DeleteTransaction
  }

  defdelegate calculate_variation(current_value, past_value), to: CalculateVariation, as: :execute

  defdelegate change_transaction(transaction, attrs \\ %{}),
    to: ChangeTransaction,
    as: :execute

  defdelegate create_transaction(attrs \\ %{}), to: CreateTransaction, as: :execute

  defdelegate delete_transaction(transaction),
    to: DeleteTransaction,
    as: :execute
end
