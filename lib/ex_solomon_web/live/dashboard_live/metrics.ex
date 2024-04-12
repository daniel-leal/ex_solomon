defmodule ExSolomonWeb.DashboardLive.Metrics do
  use Phoenix.Component

  attr :title, :string, required: true
  attr :amount, :integer, required: true
  attr :last_month_variation, :float
  attr :variation_color, :string, default: "text-rose-400"
  attr :show_variation, :boolean, default: true

  def metric_card(assigns) do
    ~H"""
    <div class={[
      "block max-w-sm p-6 bg-white border border-gray-200 rounded-lg shadow-lg
        hover:bg-gray-100 dark:bg-gray-800 dark:border-gray-700 dark:hover:bg-gray-700"
    ]}>
      <div class="flex flex-row justify-between">
        <p class="mb-2 text-base font-medium tracking-tight text-gray-900 dark:text-white">
          <%= @title %>
        </p>
        <svg
          xmlns="http://www.w3.org/2000/svg"
          width="18"
          height="18"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
          class="text-gray-500 mr-2 ml-2 lucide lucide-dollar-sign"
        >
          <line x1="12" x2="12" y1="2" y2="22" /><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6" />
        </svg>
      </div>
      <p class="text-3xl mb-2 font-bold text-gray-700 dark:text-gray-400">
        <%= Money.parse!(@amount) %>
      </p>
      <p :if={@show_variation} class="text-sm text-muted-foreground">
        <span class={@variation_color}>
          <%= @last_month_variation %>%
        </span>
        em relação ao mês anterior
      </p>
    </div>
    """
  end
end
