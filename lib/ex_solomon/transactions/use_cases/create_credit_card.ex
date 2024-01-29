defmodule ExSolomon.Transactions.UseCases.CreateCreditCard do
  alias ExSolomon.Transactions.Schemas.CreditCard
  alias ExSolomon.Repo

  @doc """
  Creates a credit_card.

  ## Examples

      iex> create_credit_card(%{field: value})
      {:ok, %CreditCard{}}

      iex> create_credit_card(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def execute(attrs \\ %{}) do
    %CreditCard{}
    |> CreditCard.changeset(attrs)
    |> Repo.insert()
  end
end
