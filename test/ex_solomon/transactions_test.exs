defmodule ExSolomon.TransactionsTest do
  use ExSolomon.DataCase, async: true
  alias ExSolomon.Transactions

  describe "categories" do
    test "list_categories/0 returns all categories" do
      categories = insert_list(3, :category)
      assert Transactions.Queries.list_categories() == categories
    end

    test "get_category/1 returns a category" do
      category = insert(:category)
      assert Transactions.Queries.get_category!(category.id) == category
    end
  end

  describe "transactions" do
    alias ExSolomon.Transactions.Schemas.Transaction

    setup %{} do
      user = insert(:user)
      category = insert(:category)
      %{user: user, category: category}
    end

    @invalid_attrs %{
      date: nil,
      description: nil,
      kind: "invalid kind",
      amount: -30,
      is_fixed: nil,
      is_revenue: nil
    }

    test "list_transactions/0 returns all transactions", %{user: user, category: category} do
      fixed_transactions =
        insert(:transaction,
          user_id: user.id,
          category_id: category.id,
          is_fixed: true,
          date: nil,
          recurring_day: 2
        )

      variable_transactions =
        insert(:transaction,
          user_id: user.id,
          category_id: category.id,
          is_fixed: false,
          recurring_day: nil,
          date: ~D[2024-01-15]
        )

      transactions = [variable_transactions, fixed_transactions]

      assert Transactions.Queries.list_transactions() == transactions
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = insert(:transaction)
      assert Transactions.Queries.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction", %{
      user: user,
      category: category
    } do
      valid_attrs =
        params_for(:transaction,
          user_id: user.id,
          category_id: category.id
        )

      assert {:ok, %Transaction{} = transaction} =
               Transactions.create_transaction(valid_attrs)

      assert transaction.date == valid_attrs[:date]
      assert transaction.description == valid_attrs[:description]
      assert transaction.kind == valid_attrs[:kind]
      assert transaction.amount == valid_attrs[:amount]
      assert transaction.is_fixed == valid_attrs[:is_fixed]
      assert transaction.is_revenue == valid_attrs[:is_revenue]
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_transaction(@invalid_attrs)
    end

    test "delete_transaction/1 deletes the transaction", %{user: user, category: category} do
      transaction = insert(:transaction, user_id: user.id, category_id: category.id)
      assert {:ok, %Transaction{}} = Transactions.delete_transaction(transaction)

      assert_raise Ecto.NoResultsError, fn ->
        Transactions.Queries.get_transaction!(transaction.id)
      end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = insert(:transaction)
      assert %Ecto.Changeset{} = Transactions.change_transaction(transaction)
    end
  end
end
