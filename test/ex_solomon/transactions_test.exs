defmodule ExSolomon.TransactionsTest do
  use ExSolomon.DataCase

  alias ExSolomon.Transactions

  describe "credit_cards" do
    alias ExSolomon.Transactions.Schemas.CreditCard

    import ExSolomon.TransactionsFixtures

    @invalid_attrs %{name: nil, limit: nil, invoice_start_day: nil}

    test "list_credit_cards/0 returns all credit_cards" do
      credit_card = credit_card_fixture()
      assert Transactions.Queries.list_credit_cards() == [credit_card]
    end

    test "get_credit_card!/1 returns the credit_card with given id" do
      credit_card = credit_card_fixture()
      assert Transactions.Queries.get_credit_card!(credit_card.id) == credit_card
    end

    test "create_credit_card/1 with valid data creates a credit_card" do
      valid_attrs = %{name: "some name", limit: Money.new(4200), invoice_start_day: 42}

      assert {:ok, %CreditCard{} = credit_card} =
               Transactions.create_credit_card(valid_attrs)

      assert credit_card.name == "some name"
      assert credit_card.limit == Money.new(4200)
      assert credit_card.invoice_start_day == 42
    end

    test "create_credit_card/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_credit_card(@invalid_attrs)
    end

    test "update_credit_card/2 with valid data updates the credit_card" do
      credit_card = credit_card_fixture()

      update_attrs = %{
        name: "some updated name",
        limit: Money.new(4300),
        invoice_start_day: 43
      }

      assert {:ok, %CreditCard{} = credit_card} =
               Transactions.update_credit_card(credit_card, update_attrs)

      assert credit_card.name == "some updated name"
      assert credit_card.limit == Money.new(4300)
      assert credit_card.invoice_start_day == 43
    end

    test "update_credit_card/2 with invalid data returns error changeset" do
      credit_card = credit_card_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Transactions.update_credit_card(credit_card, @invalid_attrs)

      assert credit_card == Transactions.Queries.get_credit_card!(credit_card.id)
    end

    test "delete_credit_card/1 deletes the credit_card" do
      credit_card = credit_card_fixture()
      assert {:ok, %CreditCard{}} = Transactions.delete_credit_card(credit_card)

      assert_raise Ecto.NoResultsError, fn ->
        Transactions.Queries.get_credit_card!(credit_card.id)
      end
    end

    test "change_credit_card/1 returns a credit_card changeset" do
      credit_card = credit_card_fixture()
      assert %Ecto.Changeset{} = Transactions.change_credit_card(credit_card)
    end
  end
end
