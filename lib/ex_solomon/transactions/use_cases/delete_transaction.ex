defmodule ExSolomon.Transactions.UseCases.DeleteTransaction do
  @moduledoc """
  Deletes a transaction.
  """

  alias ExSolomon.Repo
  alias ExSolomon.Transactions.Schemas.Transaction

  @doc """
  Deletes a transaction.

  ## Examples

      iex> delete_transaction(transaction)
      {:ok, %Transaction{}}

      iex> delete_transaction(transaction)
      {:error, %Ecto.Changeset{}}

  """
  def execute(%Transaction{} = transaction) do
    Repo.delete(transaction)
  end
end
