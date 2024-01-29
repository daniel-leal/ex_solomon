defmodule ExSolomon.Transactions.UseCases.UpdateCreditCard do
  alias ExSolomon.Transactions.Schemas.CreditCard
  alias ExSolomon.Repo

  @doc """
  Updates a credit_card.

  ## Examples

      iex> update_credit_card(credit_card, %{field: new_value})
      {:ok, %CreditCard{}}

      iex> update_credit_card(credit_card, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def execute(%CreditCard{} = credit_card, attrs) do
    credit_card
    |> CreditCard.changeset(attrs)
    |> Repo.update()
  end
end
