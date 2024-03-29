defmodule ExSolomonWeb.TransactionLive.Index do
  use ExSolomonWeb, :live_view_logged

  import ExSolomonWeb.{Buttons, Pagination}

  alias ExSolomon.CreditCards.Queries, as: CreditCardQueries
  alias ExSolomon.DateUtils
  alias ExSolomon.Filter
  alias ExSolomon.Repo
  alias ExSolomon.Transactions
  alias ExSolomon.Transactions.Queries, as: TransactionQueries
  alias ExSolomon.Transactions.Schemas.Transaction
  alias ExSolomon.Transactions.Types.TransactionTypes

  alias Phoenix.LiveView.JS

  @impl true
  def mount(_params, _session, %{assigns: %{current_user: current_user}} = socket) do
    categories = TransactionQueries.list_categories()
    credit_cards = CreditCardQueries.list_credit_cards(current_user.id)
    transaction_kinds = TransactionTypes.kinds()

    socket =
      socket
      |> assign(:categories, categories)
      |> assign(:credit_cards, credit_cards)
      |> assign(:transaction_kinds, transaction_kinds)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply,
     socket
     |> apply_action(socket.assigns.live_action, params)
     |> apply_filters(params)
     |> apply_pagination(params)}
  end

  defp apply_action(
         %{assigns: %{current_user: current_user}} = socket,
         :new,
         %{
           "revenue" => "true"
         }
       ) do
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
    |> assign(:page_title, "Transações")
    |> assign(:transaction, nil)
  end

  @impl true
  def handle_info(
        {ExSolomonWeb.TransactionLive.FormComponent, {:saved, _transaction}},
        socket
      ) do
    reload_with_params(socket)
  end

  @impl true
  def handle_info(
        {ExSolomonWeb.TransactionLive.FilterComponent, {:filtered, filters}},
        socket
      ) do
    socket
    |> assign(:filters, filters)
    |> reload_with_params()
  end

  @impl true
  def handle_event("nav", %{"page" => page}, socket) do
    socket
    |> assign(page: page)
    |> reload_with_params()
  end

  @impl true
  def handle_event("change_page_size", %{"page_size" => page_size}, socket) do
    socket
    |> assign(page_size: page_size)
    |> reload_with_params()
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    transaction = Transactions.Queries.get_transaction!(id)
    {:ok, _} = Transactions.delete_transaction(transaction)
    reload_with_params(socket)
  end

  defp apply_filters(socket, params) do
    assign(socket, :filters, %{
      date_gte: Map.get(params, "date_gte"),
      date_lte: Map.get(params, "date_lte"),
      kind: Map.get(params, "kind"),
      is_fixed: Map.get(params, "is_fixed"),
      is_revenue: Map.get(params, "is_revenue"),
      category_id: Map.get(params, "category_id"),
      credit_card_id: Map.get(params, "credit_card_id")
    })
  end

  defp apply_pagination(%{assigns: %{current_user: current_user}} = socket, params) do
    filters =
      socket
      |> Map.get(:assigns)
      |> Map.get(:filters, %{})
      |> Map.update!(:date_gte, fn
        nil -> nil
        "" -> ""
        date_str -> DateUtils.parse_date(date_str)
      end)
      |> Map.update!(:date_lte, fn
        nil -> nil
        "" -> ""
        date_str -> DateUtils.parse_date(date_str)
      end)

    %Scrivener.Page{
      page_number: page_number,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages,
      entries: entries
    } =
      TransactionQueries.list_transactions(current_user.id)
      |> Filter.fetch(filters)
      |> Repo.paginate(params)

    socket
    |> assign(:page_size, page_size)
    |> assign(:page, page_number)
    |> assign(:total_entries, total_entries)
    |> assign(:total_pages, total_pages)
    |> stream(:transactions, entries)
  end

  defp reload_with_params(
         %{
           assigns: %{
             page: page,
             page_size: page_size,
             filters: filters
           }
         } = socket
       ) do
    query_params =
      %{page_size: page_size}
      |> Map.merge(%{page: page})
      |> Map.merge(filters)
      |> URI.encode_query()

    socket =
      socket
      |> apply_filters(filters)
      |> apply_pagination(%{"page" => page, "page_size" => page_size})

    {:noreply, push_navigate(socket, to: "/transactions?#{query_params}")}
  end
end
