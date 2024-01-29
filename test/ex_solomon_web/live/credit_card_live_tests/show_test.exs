defmodule ExSolomonWeb.CreditCardLiveTests.ShowTest do
  use ExSolomonWeb.ConnCase

  import Phoenix.LiveViewTest
  import ExSolomon.TransactionsFixtures

  @update_attrs %{name: "some updated name", limit: 43, invoice_start_day: 43}
  @invalid_attrs %{name: nil, limit: nil, invoice_start_day: nil}

  defp create_credit_card(_) do
    credit_card = credit_card_fixture()
    %{credit_card: credit_card}
  end

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
