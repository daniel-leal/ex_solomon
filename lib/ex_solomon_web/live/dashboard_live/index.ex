defmodule ExSolomonWeb.DashboardLive.Index do
  use ExSolomonWeb, :live_view_logged

  import ExSolomonWeb.Charts
  import ExSolomonWeb.DashboardLive.Metrics
  import ExSolomon.DateUtils

  alias ExSolomon.Transactions.Queries, as: TransactionsQueries

  @impl true
  def mount(_params, _session, %{assigns: %{current_user: current_user}} = socket) do
    categories = Enum.map(TransactionsQueries.list_categories(), & &1.description)
    monthly_revenue = TransactionsQueries.month_revenue(Timex.now(), current_user.id)

    last_month_variation =
      TransactionsQueries.revenue_variation(monthly_revenue, current_user.id)

    socket =
      socket
      |> assign(:categories, categories)
      |> assign(:monthly_revenue, monthly_revenue)
      |> assign(:last_month_variation, last_month_variation)

    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, assign(socket, :page_title, "Dashboard")}
  end
end
