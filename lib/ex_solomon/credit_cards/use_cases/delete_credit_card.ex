defmodule ExSolomon.CreditCards.UseCases.DeleteCreditCard do
  alias ExSolomon.CreditCards.Schemas.CreditCard
  alias ExSolomon.Repo

  @doc """
  Deletes a credit_card.

  ## Examples

      iex> delete_credit_card(credit_card)
      {:ok, %CreditCard{}}

      iex> delete_credit_card(credit_card)
      {:error, %Ecto.Changeset{}}

  """
  def execute(%CreditCard{} = credit_card) do
    Repo.delete(credit_card)
  end
end
