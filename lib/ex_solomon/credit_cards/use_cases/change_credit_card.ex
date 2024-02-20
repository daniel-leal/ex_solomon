defmodule ExSolomon.CreditCards.UseCases.ChangeCreditCard do
  alias ExSolomon.CreditCards.Schemas.CreditCard

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking credit_card changes.

  ## Examples

      iex> change_credit_card(credit_card)
      %Ecto.Changeset{data: %CreditCard{}}

  """
  def execute(%CreditCard{} = credit_card, attrs \\ %{}) do
    CreditCard.changeset(credit_card, attrs)
  end
end
