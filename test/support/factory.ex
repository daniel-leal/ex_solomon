defmodule Support.Factory do
  use ExMachina.Ecto, repo: ExSolomon.Repo

  alias ExSolomon.Accounts.Schemas.User
  alias ExSolomon.CreditCards.Schemas.CreditCard
  alias ExSolomon.Transactions.Schemas.{Category, Transaction}

  def user_factory do
    %User{
      email: sequence(:email, &"user#{&1}@example.com"),
      password: "password",
      hashed_password: Bcrypt.hash_pwd_salt("password"),
      confirmed_at: DateTime.utc_now()
    }
  end

  def category_factory do
    %Category{
      description: sequence(:category, ["Food", "Transport", "Entertainment"])
    }
  end

  def credit_card_factory do
    %CreditCard{
      name: sequence(:name, ["Visa", "Mastercard", "Amex"]),
      limit: sequence(:limit, [1000, 2000, 3000]),
      invoice_start_day: :rand.uniform(29)
    }
  end

  def transaction_factory do
    %Transaction{
      description: sequence(:transaction, ["iFood", "Uber", "Spotify", "Formosa"]),
      kind: "pix",
      amount: sequence(:amount, [Money.new(100), Money.new(200), Money.new(300)]),
      is_fixed: false,
      is_revenue: false,
      date: sequence(:date, [~D[2019-01-01], ~D[2019-01-02], ~D[2019-01-03]]),
      recurring_day: sequence(:recurring_day, [1, 5, 10])
    }
  end
end
