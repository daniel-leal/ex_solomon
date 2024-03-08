defmodule ExSolomonWeb.TransactionLive.Index do
  use ExSolomonWeb, :live_view_logged

  alias ExSolomon.Transactions
  alias ExSolomon.Transactions.Schemas.Transaction
  alias ExSolomon.Transactions.Queries, as: TransactionQueries
  alias ExSolomon.Transactions.Types.TransactionTypes

  import ExSolomonWeb.{Buttons, Pagination}

  @impl true
  def mount(params, _session, socket) do
    categories = TransactionQueries.list_categories()
    transaction_kinds = TransactionTypes.kinds()

    socket =
      socket
      |> assign(:categories, categories)
      |> assign(:transaction_kinds, transaction_kinds)
      |> assign_pagination(params)

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

  defp apply_action(socket, :index, %{"page_size" => page_size, "page" => page}) do
    socket
    |> assign(:page_title, "Transações")
    |> assign(:page_size, page_size)
    |> assign(:page_number, String.to_integer(page))
    |> assign(:transaction, nil)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Transações")
    |> assign(:transaction, nil)
  end

  @impl true
  def handle_info(
        {ExSolomonWeb.TransactionLive.FormComponent, {:saved, _transaction}},
        socket
      ) do
    assigns = Map.get(socket, :assigns)
    page_number = Map.get(assigns, :page_number)
    page_size = Map.get(assigns, :page_size)
    params = %{page_size: page_size, page_number: page_number}

    {:noreply, assign_pagination(socket, params)}
  end

  @impl true
  def handle_event("nav", %{"page" => page}, socket) do
    page_size = Map.get(socket.assigns, :page_size, 10)
    {:noreply, push_navigate(socket, to: ~p"/transactions?page=#{page}&page_size=#{page_size}")}
  end

  @impl true
  def handle_event("change_page_size", %{"page_size" => page_size}, socket) do
    page =
      socket
      |> Map.get(:assigns)
      |> Map.get(:page_number, 1)

    {:noreply, push_navigate(socket, to: ~p"/transactions?page=#{page}&page_size=#{page_size}")}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    transaction = Transactions.Queries.get_transaction!(id)
    {:ok, _} = Transactions.delete_transaction(transaction)
    assigns = Map.get(socket, :assigns)

    page_number = Map.get(assigns, :page_number)
    page_size = Map.get(assigns, :page_size)

    params = %{page_size: page_size, page_number: page_number}

    {:noreply, assign_pagination(socket, params)}
  end

  defp assign_pagination(socket, pagination_params) do
    %Scrivener.Page{
      page_number: page_number,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages,
      entries: entries
    } = TransactionQueries.list_transactions(pagination_params)

    socket
    |> assign(:page_size, page_size)
    |> assign(:page_number, page_number)
    |> assign(:total_entries, total_entries)
    |> assign(:total_pages, total_pages)
    |> stream(:transactions, entries)
  end
end
