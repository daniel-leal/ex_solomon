defmodule ExSolomon.Transactions.Queries do
  alias ExSolomon.Transactions.Schemas.CreditCard
  alias ExSolomon.Repo

  import Ecto.Query, warn: false

  @doc """
  Returns the list of credit_cards.

  ## Examples

      iex> list_credit_cards()
      [%CreditCard{}, ...]

  """
  def list_credit_cards do
    Repo.all(CreditCard)
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
