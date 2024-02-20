defmodule ExSolomon.Transactions.UseCases.CreateTransaction do
  @moduledoc """
  Creates a transaction.
  """

  alias ExSolomon.Repo
  alias ExSolomon.Transactions.Schemas.Transaction

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def execute(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end
end
