defmodule ExSolomonWeb.CreditCardLive.Show do
  use ExSolomonWeb, :live_view_logged

  alias ExSolomon.CreditCards.Queries, as: CreditCardsQueries
  alias ExSolomon.CreditCards.Schemas.CreditCard
  alias ExSolomon.Transactions.Queries, as: TransactionQueries

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, %{assigns: %{current_user: current_user}} = socket) do
    credit_card = CreditCardsQueries.get_credit_card!(id)
    transactions = TransactionQueries.list_current_invoice_transactions(current_user.id, id)

    total_invoice =
      Enum.reduce(transactions, Money.new(0), fn t, acc -> Money.add(acc, t.amount) end)

    invoice_period =
      credit_card
      |> CreditCard.get_current_invoice()
      |> ExSolomonWeb.Helpers.display_current_invoice()

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:credit_card, CreditCardsQueries.get_credit_card!(id))
     |> assign(:total_invoice, total_invoice)
     |> assign(:invoice_period, invoice_period)
     |> assign(:transactions, transactions)}
  end

  defp page_title(:show), do: "Exibir Cartão"
  defp page_title(:edit), do: "Editar Cartão"
end
