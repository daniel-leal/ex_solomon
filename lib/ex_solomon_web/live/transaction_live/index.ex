defmodule ExSolomonWeb.TransactionLive.Index do
  use ExSolomonWeb, :live_view

  alias ExSolomon.Transactions
  alias ExSolomon.Transactions.Schemas.Transaction
  alias ExSolomon.Transactions.Queries, as: TransactionQueries
  alias ExSolomon.Transactions.Types.TransactionTypes
  import ExSolomonWeb.Buttons

  @impl true
  def mount(_params, _session, socket) do
    categories = TransactionQueries.list_categories()
    transaction_kinds = TransactionTypes.kinds()

    socket =
      socket
      |> assign(:categories, categories)
      |> assign(:transaction_kinds, transaction_kinds)
      |> stream(:transactions, Transactions.Queries.list_transactions())

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(%{assigns: %{current_user: current_user}} = socket, :new, %{
         "is_revenue" => "true"
       }) do
    socket
    |> assign(:page_title, "Nova receita")
    |> assign(:transaction, %Transaction{is_revenue: "true", user_id: current_user.id})
  end

  defp apply_action(%{assigns: %{current_user: current_user}} = socket, :new, _params) do
    socket
    |> assign(:page_title, "Nova despesa")
    |> assign(:transaction, %Transaction{user_id: current_user.id})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listagem de Transações")
    |> assign(:transaction, nil)
  end

  @impl true
  def handle_info(
        {ExSolomonWeb.TransactionLive.FormComponent, {:saved, transaction}},
        socket
      ) do
    {:noreply, stream_insert(socket, :transactions, transaction)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    transaction = Transactions.Queries.get_transaction!(id)
    {:ok, _} = Transactions.delete_transaction(transaction)

    {:noreply, stream_delete(socket, :transactions, transaction)}
  end
end
