defmodule ExSolomonWeb.CreditCardLive.Show do
  use ExSolomonWeb, :live_view

  alias ExSolomon.CreditCards
  alias CreditCards.Queries, as: CreditCardsQueries

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:credit_card, CreditCardsQueries.get_credit_card!(id))}
  end

  defp page_title(:show), do: "Show Credit card"
  defp page_title(:edit), do: "Edit Credit card"
end
