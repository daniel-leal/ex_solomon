defmodule ExSolomon.CreditCardsTest do
  use ExSolomon.DataCase, async: true

  alias ExSolomon.CreditCards
  import ExSolomon.CreditCardsFixtures
  import Mox

  describe "credit_cards" do
    alias ExSolomon.CreditCards.Schemas.CreditCard

    @invalid_attrs %{name: nil, limit: nil, invoice_start_day: nil}

    test "list_credit_cards/0 returns all credit_cards" do
      credit_card = credit_card_fixture()
      assert CreditCards.Queries.list_credit_cards() == [credit_card]
    end

    test "get_credit_card!/1 returns the credit_card with given id" do
      credit_card = credit_card_fixture()
      assert CreditCards.Queries.get_credit_card!(credit_card.id) == credit_card
    end

    test "create_credit_card/1 with valid data creates a credit_card" do
      valid_attrs = %{invoice_start_day: 28, limit: 20000, name: "Visa"}

      assert {:ok, %CreditCard{} = credit_card} = CreditCards.create_credit_card(valid_attrs)

      assert credit_card.name == "Visa"
      assert credit_card.limit == Money.new(20000)
      assert credit_card.invoice_start_day == 28
    end

    test "create_credit_card/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CreditCards.create_credit_card(@invalid_attrs)
    end

    test "update_credit_card/2 with valid data updates the credit_card" do
      credit_card = credit_card_fixture()

      update_attrs = %{
        name: "some updated name",
        limit: Money.new(4300),
        invoice_start_day: 15
      }

      assert {:ok, %CreditCard{} = credit_card} =
               CreditCards.update_credit_card(credit_card, update_attrs)

      assert credit_card.name == "some updated name"
      assert credit_card.limit == Money.new(4300)
      assert credit_card.invoice_start_day == 15
    end

    test "update_credit_card/2 with invalid data returns error changeset" do
      credit_card = credit_card_fixture()

      assert {:error, %Ecto.Changeset{}} =
               CreditCards.update_credit_card(credit_card, @invalid_attrs)

      assert credit_card == CreditCards.Queries.get_credit_card!(credit_card.id)
    end

    test "delete_credit_card/1 deletes the credit_card" do
      credit_card = credit_card_fixture()
      assert {:ok, %CreditCard{}} = CreditCards.delete_credit_card(credit_card)

      assert_raise Ecto.NoResultsError, fn ->
        CreditCards.Queries.get_credit_card!(credit_card.id)
      end
    end

    test "change_credit_card/1 returns a credit_card changeset" do
      credit_card = credit_card_fixture()
      assert %Ecto.Changeset{} = CreditCards.change_credit_card(credit_card)
    end

    test "get_current_invoice/1 returns a invoice period" do
      credit_card = %CreditCard{invoice_start_day: 7}
      current_date = ~D[2024-02-24]
      expect(TimexMock, :now, fn -> current_date end)

      result = CreditCard.get_current_invoice(credit_card)

      expected_period = "07/02/2024 - 06/03/2024"

      assert String.contains?(result, expected_period)
    end
  end
end
