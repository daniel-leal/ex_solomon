defmodule ExSolomon.Transactions.Queries do
  alias ExSolomon.Transactions.Schemas.{Category, Transaction}
  alias ExSolomon.Repo

  import Ecto.Query, warn: false

  ### Categories Queries

  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]
  """
  def list_categories do
    Repo.all(Category)
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)
  """
  def get_category!(id), do: Repo.get!(Category, id)

  @doc """
  Returns a queryable fixed transactions
  """
  def fixed_transactions_query do
    from t in Transaction, where: t.is_fixed
  end

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions()
      [%Transaction{}...]

  """
  def list_transactions() do
    fixed_transactions = fixed_transactions_query()

    union_query =
      from q in Transaction,
        where: not q.is_fixed,
        union: ^fixed_transactions

    from s in subquery(union_query),
      join: c in assoc(s, :category),
      order_by: [desc_nulls_last: s.date, asc: s.recurring_day],
      preload: [:category]
  end

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(id) do
    Transaction
    |> Repo.get!(id)
    |> Repo.preload(:category)
    |> Repo.preload(:credit_card)
  end
end
