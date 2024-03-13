defmodule ExSolomonWeb.TransactionLive.Index do
  use ExSolomonWeb, :live_view_logged

  alias Phoenix.LiveView.JS

  alias ExSolomon.Filter
  alias ExSolomon.Repo
  alias ExSolomon.Transactions
  alias ExSolomon.Transactions.Schemas.Transaction
  alias ExSolomon.Transactions.Queries, as: TransactionQueries
  alias ExSolomon.Transactions.Types.TransactionTypes

  import ExSolomonWeb.{Buttons, Pagination}

  @impl true
  def mount(_params, _session, socket) do
    categories = TransactionQueries.list_categories()
    transaction_kinds = TransactionTypes.kinds()

    socket =
      socket
      |> assign(:categories, categories)
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
        %{
          assigns: %{
            page_number: page_number,
            page_size: page_size
          }
        } = socket
      ) do
    {:noreply, apply_pagination(socket, %{page_size: page_size, page_number: page_number})}
  end

  @impl true
  def handle_info(
        {ExSolomonWeb.TransactionLive.FilterComponent, {:filtered, filters}},
        %{
          assigns: %{
            page_number: page_number,
            page_size: page_size
          }
        } = socket
      ) do
    IO.inspect(filters)

    query_params =
      %{page_size: page_size}
      |> Map.merge(%{page_number: page_number})
      |> Map.merge(filters)
      |> URI.encode_query()

    socket = apply_pagination(socket, %{"page_number" => page_number, "page_size" => page_size})

    {:noreply, push_navigate(socket, to: "/transactions?#{query_params}")}
  end

  @impl true
  def handle_event(
        "nav",
        %{"page" => page},
        %{
          assigns: %{
            page_size: page_size,
            filters: filters
          }
        } = socket
      ) do
    query_params =
      %{page: page}
      |> Map.merge(%{page_size: page_size})
      |> Map.merge(filters)
      |> URI.encode_query()

    {:noreply, push_navigate(socket, to: "/transactions?#{query_params}")}
  end

  @impl true
  def handle_event(
        "change_page_size",
        %{"page_size" => page_size},
        %{
          assigns: %{
            page_number: page_number,
            filters: filters
          }
        } = socket
      ) do
    query_params =
      %{page_size: page_size}
      |> Map.merge(%{page: page_number})
      |> Map.merge(filters)
      |> URI.encode_query()

    {:noreply, push_navigate(socket, to: "/transactions?#{query_params}")}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    transaction = Transactions.Queries.get_transaction!(id)
    {:ok, _} = Transactions.delete_transaction(transaction)
    assigns = Map.get(socket, :assigns)

    page_number = Map.get(assigns, :page_number)
    page_size = Map.get(assigns, :page_size)

    params = %{page_size: page_size, page_number: page_number}

    {:noreply, apply_pagination(socket, params)}
  end

  defp apply_filters(socket, params) do
    assign(socket, :filters, %{
      kind: Map.get(params, "kind"),
      is_fixed: Map.get(params, "is_fixed"),
      is_revenue: Map.get(params, "is_revenue"),
      category_id: Map.get(params, "category_id")
    })
  end

  defp apply_pagination(socket, params) do
    filters = Map.get(socket.assigns, :filters, %{})

    %Scrivener.Page{
      page_number: page_number,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages,
      entries: entries
    } =
      TransactionQueries.list_transactions()
      |> Filter.fetch(filters)
      |> Repo.paginate(params)

    socket
    |> assign(:page_size, page_size)
    |> assign(:page_number, page_number)
    |> assign(:total_entries, total_entries)
    |> assign(:total_pages, total_pages)
    |> stream(:transactions, entries)
  end
end
