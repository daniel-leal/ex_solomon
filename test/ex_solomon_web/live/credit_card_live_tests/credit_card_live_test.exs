defmodule ExSolomonWeb.CreditCardLiveTest do
  use ExSolomonWeb.ConnCase

  import Phoenix.LiveViewTest
  import ExSolomon.TransactionsFixtures

  @create_attrs %{name: "some name", limit: 42, invoice_start_day: 42}
  @update_attrs %{name: "some updated name", limit: 43, invoice_start_day: 43}
  @invalid_attrs %{name: nil, limit: nil, invoice_start_day: nil}

  defp create_credit_card(_) do
    credit_card = credit_card_fixture()
    %{credit_card: credit_card}
  end

  describe "Index" do
    setup [:create_credit_card, :register_and_log_in_user]

    test "lists all credit_cards", %{conn: conn, credit_card: credit_card} do
      {:ok, _index_live, html} = live(conn, ~p"/credit_cards")

      assert html =~ "Listing Credit cards"
      assert html =~ credit_card.name
    end

    test "saves new credit_card", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/credit_cards")

      assert index_live |> element("a", "New Credit card") |> render_click() =~
               "New Credit card"

      assert_patch(index_live, ~p"/credit_cards/new")

      assert index_live
             |> form("#credit_card-form", credit_card: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#credit_card-form", credit_card: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/credit_cards")

      html = render(index_live)
      assert html =~ "Credit card created successfully"
      assert html =~ "some name"
    end

    test "updates credit_card in listing", %{conn: conn, credit_card: credit_card} do
      {:ok, index_live, _html} = live(conn, ~p"/credit_cards")

      assert index_live
             |> element("#credit_cards-#{credit_card.id} a", "Edit")
             |> render_click() =~
               "Edit Credit card"

      assert_patch(index_live, ~p"/credit_cards/#{credit_card}/edit")

      assert index_live
             |> form("#credit_card-form", credit_card: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#credit_card-form", credit_card: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/credit_cards")

      html = render(index_live)
      assert html =~ "Credit card updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes credit_card in listing", %{conn: conn, credit_card: credit_card} do
      {:ok, index_live, _html} = live(conn, ~p"/credit_cards")

      assert index_live
             |> element("#credit_cards-#{credit_card.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#credit_cards-#{credit_card.id}")
    end
  end

  describe "Show" do
    setup [:create_credit_card, :register_and_log_in_user]

    test "displays credit_card", %{conn: conn, credit_card: credit_card} do
      {:ok, _show_live, html} = live(conn, ~p"/credit_cards/#{credit_card}")

      assert html =~ "Show Credit card"
      assert html =~ credit_card.name
    end

    test "updates credit_card within modal", %{conn: conn, credit_card: credit_card} do
      {:ok, show_live, _html} = live(conn, ~p"/credit_cards/#{credit_card}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Credit card"

      assert_patch(show_live, ~p"/credit_cards/#{credit_card}/show/edit")

      assert show_live
             |> form("#credit_card-form", credit_card: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#credit_card-form", credit_card: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/credit_cards/#{credit_card}")

      html = render(show_live)
      assert html =~ "Credit card updated successfully"
      assert html =~ "some updated name"
    end
  end
end
