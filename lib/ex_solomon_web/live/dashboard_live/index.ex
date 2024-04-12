defmodule ExSolomonWeb.DashboardLive.Index do
  use ExSolomonWeb, :live_view_logged

  import ExSolomonWeb.Charts
  import ExSolomonWeb.DashboardLive.Metrics
  import ExSolomon.DateUtils

  alias ExSolomon.Transactions.Queries, as: TransactionsQueries

  @impl true
  def mount(_params, _session, %{assigns: %{current_user: current_user}} = socket) do
    current_date = Timex.now()
    categories = Enum.map(TransactionsQueries.list_categories(), & &1.description)
    monthly_revenue = TransactionsQueries.month_revenue(current_date, current_user.id)
    monthly_expense = TransactionsQueries.month_expense(current_date, current_user.id)

    month_revenue_variation =
      TransactionsQueries.revenue_variation(monthly_revenue, current_user.id)

    month_expense_variation =
      TransactionsQueries.expense_variation(monthly_expense, current_user.id)

    socket =
      socket
      |> assign(:categories, categories)
      |> assign(:monthly_revenue, monthly_revenue)
      |> assign(:month_revenue_variation, month_revenue_variation)
      |> assign(:monthly_expense, monthly_expense)
      |> assign(:month_expense_variation, month_expense_variation)

    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, assign(socket, :page_title, "Dashboard")}
  end
end
