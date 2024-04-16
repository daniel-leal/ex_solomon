defmodule ExSolomon.Transactions.Queries do
  alias ExSolomon.Repo

  alias ExSolomon.CreditCards.Queries, as: CreditCardQueries
  alias ExSolomon.CreditCards.Schemas.CreditCard
  alias ExSolomon.Transactions.Schemas.{Category, Transaction}

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
  def fixed_transactions_query(user_id) do
    from t in Transaction, where: t.is_fixed and t.user_id == ^user_id
  end

  @doc """
  Returns a queryable fixed transactions
  """
  def variable_transactions_query(user_id) do
    from t in Transaction, where: not t.is_fixed and t.user_id == ^user_id
  end

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions()
      [%Transaction{}...]

  """
  def list_transactions(user_id) do
    fixed_transactions = fixed_transactions_query(user_id)

    union_query =
      from q in Transaction,
        where: not q.is_fixed and q.user_id == ^user_id,
        union: ^fixed_transactions

    from s in subquery(union_query),
      join: c in assoc(s, :category),
      order_by: [desc_nulls_last: s.date, asc: s.recurring_day],
      preload: [:category]
  end

  @doc """
  Retrieves a list of transactions for the current invoice period associated with the given user
  and credit card.

  ## Parameters
    - `user_id`: The ID of the user for whom the transactions are being fetched.
    - `credit_card_id`: The ID of the credit card for which transactions are to be retrieved.

  ## Returns
  A list of transactions within the current invoice period associated with the specified user and
  credit card.

  ## Examples
      iex> list_current_invoice_transactions(123, 456)
      [%Transaction{...}, %Transaction{...}, ...]

  """
  def list_current_invoice_transactions(user_id, credit_card_id) do
    transactions = list_transactions(user_id)
    credit_card = CreditCardQueries.get_credit_card!(credit_card_id)
    {start_invoice, end_invoice} = CreditCard.get_current_invoice(credit_card)

    query =
      from t in transactions,
        where:
          t.credit_card_id == ^credit_card_id and
            t.date >= ^start_invoice and
            t.date <= ^end_invoice

    Repo.all(query)
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

  def fixed_revenue(user_id) do
    fixed_transactions = fixed_transactions_query(user_id)

    fixed_revenue_query =
      from f in fixed_transactions, where: f.is_revenue, select: sum(f.amount)

    result = Repo.one(fixed_revenue_query) || Money.new(0)
    Money.to_decimal(result)
  end

  def fixed_expenses(user_id) do
    fixed_transactions = fixed_transactions_query(user_id)

    fixed_expenses_query =
      from f in fixed_transactions, where: not f.is_revenue, select: sum(f.amount)

    result = Repo.one(fixed_expenses_query) || Money.new(0)
    Money.to_decimal(result)
  end

  def variable_expenses(date, user_id) do
    beginning_of_month = Timex.beginning_of_month(date)
    end_of_month = Timex.end_of_month(date)
    variable_transactions = variable_transactions_query(user_id)

    variable_expenses_query =
      from f in variable_transactions,
        where:
          not f.is_revenue and
            f.date >= ^beginning_of_month and
            f.date <= ^end_of_month,
        select: sum(f.amount)

    result = Repo.one(variable_expenses_query) || Money.new(0)
    Money.to_decimal(result)
  end

  @doc """
  Calculates the total revenue for the specified user within the given month.

  ## Parameters
    - `date`: The date for which the month's revenue is calculated.
    - `user_id`: The ID of the user for whom the revenue is being calculated.

  ## Returns
  The total revenue as a decimal for the specified user within the given month.

  ## Examples
      iex> month_revenue(~D[2024-04-01], 123)
      #Decimal<1234.56>
  """
  def month_revenue(date, user_id) do
    beginning_of_month = Timex.beginning_of_month(date)
    end_of_month = Timex.end_of_month(date)

    fixed_revenue = fixed_revenue(user_id)

    query =
      from t in Transaction,
        where:
          t.is_revenue and
            t.user_id == ^user_id and
            t.date >= ^beginning_of_month and
            t.date <= ^end_of_month,
        select: sum(t.amount)

    revenue_money = Repo.one(query) || Money.new(0)
    revenue = Money.to_decimal(revenue_money)

    Decimal.add(revenue, fixed_revenue)
  end

  @doc """
  Calculates the total expense for the specified user within the given month.

  ## Parameters
    - `date`: The date for which the month's expense is calculated.
    - `user_id`: The ID of the user for whom the expense is being calculated.

  ## Returns
  The total expense as a decimal for the specified user within the given month.

  ## Examples
      iex> month_revenue(~D[2024-04-01], 123)
      #Decimal<1234.56>
  """
  def month_expense(date, user_id) do
    beginning_of_month = Timex.beginning_of_month(date)
    end_of_month = Timex.end_of_month(date)

    fixed_expenses = fixed_expenses(user_id)

    query =
      from t in Transaction,
        where:
          not t.is_revenue and
            t.user_id == ^user_id and
            t.date >= ^beginning_of_month and
            t.date <= ^end_of_month,
        select: sum(t.amount)

    expense_money = Repo.one(query) || Money.new(0)
    expense = Money.to_decimal(expense_money)

    Decimal.add(expense, fixed_expenses)
  end
end
