defmodule ExSolomonWeb.TransactionLive.Show do
  use ExSolomonWeb, :live_view_logged

  alias ExSolomon.Transactions
  alias ExSolomon.Transactions.Types.TransactionTypes

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:transaction, Transactions.Queries.get_transaction!(id))}
  end

  defp page_title(:show), do: "Exibir Transação"
end
