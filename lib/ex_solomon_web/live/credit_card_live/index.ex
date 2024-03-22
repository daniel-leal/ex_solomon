defmodule ExSolomonWeb.CreditCardLive.Index do
  use ExSolomonWeb, :live_view_logged

  alias ExSolomon.CreditCards
  alias CreditCards.Queries, as: CreditCardsQueries
  alias ExSolomon.CreditCards.Schemas.CreditCard

  @impl true
  def mount(_params, _session, %{assigns: %{current_user: current_user}} = socket) do
    {:ok, stream(socket, :credit_cards, CreditCardsQueries.list_credit_cards(current_user.id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Editar Cartão")
    |> assign(:credit_card, CreditCardsQueries.get_credit_card!(id))
  end

  defp apply_action(%{assigns: %{current_user: current_user}} = socket, :new, _params) do
    socket
    |> assign(:page_title, "Novo cartão")
    |> assign(:credit_card, %CreditCard{limit: Money.new(000), user_id: current_user.id})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Cartões de crédito")
    |> assign(:credit_card, nil)
  end

  @impl true
  def handle_info(
        {ExSolomonWeb.CreditCardLive.FormComponent, {:saved, credit_card}},
        socket
      ) do
    {:noreply, stream_insert(socket, :credit_cards, credit_card)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    credit_card = CreditCardsQueries.get_credit_card!(id)
    {:ok, _} = CreditCards.delete_credit_card(credit_card)

    {:noreply, stream_delete(socket, :credit_cards, credit_card)}
  end
end
