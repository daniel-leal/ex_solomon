defmodule ExSolomon.Transactions.UseCases.ChangeTransaction do
  @moduledoc """
  Changes a transaction.
  """

  alias ExSolomon.Transactions.Schemas.Transaction

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(transaction)
      %Ecto.Changeset{data: %Transaction{}}

  """
  def execute(%Transaction{} = transaction, attrs \\ %{}) do
    Transaction.changeset(transaction, attrs)
  end
end
