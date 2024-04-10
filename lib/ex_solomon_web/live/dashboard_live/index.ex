defmodule ExSolomonWeb.DashboardLive.Index do
  use ExSolomonWeb, :live_view_logged

  import ExSolomonWeb.Charts
  import ExSolomonWeb.DashboardLive.Metrics
  import ExSolomon.DateUtils

  alias ExSolomon.Transactions.Queries, as: TransactionsQueries

  @impl true
  def mount(_params, _session, socket) do
    categories = Enum.map(TransactionsQueries.list_categories(), & &1.description)

    {:ok,
     assign(
       socket,
       :categories,
       categories
     )}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, assign(socket, :page_title, "Dashboard")}
  end
end
