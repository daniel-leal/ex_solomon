defmodule ExSolomon.CreditCards.Queries do
  alias ExSolomon.CreditCards.Schemas.CreditCard
  alias ExSolomon.Repo

  import Ecto.Query, warn: false

  @doc """
  Returns the list of credit_cards of a specific user.

  ## Examples

      iex> list_credit_cards(user)
      [%CreditCard{}, ...]

  """
  def list_credit_cards(user_id) do
    query = from c in CreditCard, where: c.user_id == ^user_id
    Repo.all(query)
  end

  @doc """
  Gets a single credit_card.

  Raises `Ecto.NoResultsError` if the Credit card does not exist.

  ## Examples

      iex> get_credit_card!(123)
      %CreditCard{}

      iex> get_credit_card!(456)
      ** (Ecto.NoResultsError)

  """
  def get_credit_card!(id), do: Repo.get!(CreditCard, id)
end
