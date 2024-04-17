defmodule ExSolomonWeb.DashboardLive.Index do
  use ExSolomonWeb, :live_view_logged

  import ExSolomonWeb.Charts
  import ExSolomonWeb.DashboardLive.Metrics
  import ExSolomon.DateUtils

  alias ExSolomon.Transactions
  alias ExSolomon.Transactions.Queries, as: TransactionsQueries

  @impl true
  def mount(_params, _session, %{assigns: %{current_user: current_user}} = socket) do
    current_date = Timex.now()
    last_month = Timex.shift(current_date, months: -1)

    monthly_revenue = TransactionsQueries.month_revenue(current_date, current_user.id)
    last_month_revenue = TransactionsQueries.month_revenue(last_month, current_user.id)

    monthly_revenue_variation =
      Transactions.calculate_variation(monthly_revenue, last_month_revenue)

    last_month_expense = TransactionsQueries.month_expense(last_month, current_user.id)

    monthly_variable_expenses =
      TransactionsQueries.variable_expenses(current_date, current_user.id)

    last_month_variable_expenses =
      TransactionsQueries.variable_expenses(last_month, current_user.id)

    monthly_variable_expenses_variation =
      Transactions.calculate_variation(monthly_variable_expenses, last_month_variable_expenses)

    fixed_expenses = TransactionsQueries.fixed_expenses(current_user.id)

    monthly_expense = Decimal.add(monthly_variable_expenses, fixed_expenses)

    monthly_expense_variation =
      Transactions.calculate_variation(monthly_expense, last_month_expense)

    monthly_result = Decimal.sub(monthly_revenue, monthly_expense)
    last_month_result = Decimal.sub(last_month_revenue, last_month_expense)
    monthly_result_variation = Transactions.calculate_variation(monthly_result, last_month_result)

    last6_months_revenue =
      Enum.map(6..1, fn x ->
        Timex.now()
        |> Timex.shift(months: -x)
        |> TransactionsQueries.month_revenue(current_user.id)
      end)

    last6_months_expense =
      Enum.map(6..1, fn x ->
        Timex.now()
        |> Timex.shift(months: -x)
        |> TransactionsQueries.month_expense(current_user.id)
      end)

    categories_expenses = TransactionsQueries.get_categories_expenses(current_user.id)

    socket =
      socket
      |> assign(:monthly_revenue, monthly_revenue)
      |> assign(:monthly_revenue_variation, monthly_revenue_variation)
      |> assign(:monthly_expense, monthly_expense)
      |> assign(:monthly_expense_variation, monthly_expense_variation)
      |> assign(:monthly_result, monthly_result)
      |> assign(:monthly_result_variation, monthly_result_variation)
      |> assign(:fixed_expenses, fixed_expenses)
      |> assign(:monthly_variable_expenses, monthly_variable_expenses)
      |> assign(:monthly_variable_expenses_variation, monthly_variable_expenses_variation)
      |> assign(:last6_months_revenue, last6_months_revenue)
      |> assign(:last6_months_expense, last6_months_expense)
      |> assign(:categories_expenses, categories_expenses)

    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, assign(socket, :page_title, "Dashboard")}
  end
end
