defmodule ExSolomonWeb.Charts do
  @moduledoc """
  Holds the charts components
  """
  use Phoenix.Component

  attr :id, :string, required: true
  attr :title, :string, default: ""
  attr :subtitle, :string, default: ""
  attr :dataset, :list, default: []
  attr :categories, :list, default: []

  def bar_chart(assigns) do
    ~H"""
    <div class="w-full bg-white rounded-lg shadow dark:bg-gray-800 p-4 md:p-6 col-span-2">
      <h5 class="text-md leading-none text-gray-900 dark:text-white pe-1">
        <%= @title %>
      </h5>
      <span class="text-sm text-muted-foreground">
        <%= @subtitle %>
      </span>
      <div
        id={@id}
        phx-hook="BarChart"
        data-series={Jason.encode!(@dataset)}
        data-categories={Jason.encode!(@categories)}
      />
    </div>
    """
  end

  attr :id, :string, required: true
  attr :title, :string, default: ""
  attr :dataset, :list, default: []
  attr :categories, :list, default: []

  def donut_chart(assigns) do
    ~H"""
    <div class="w-full bg-white rounded-lg shadow dark:bg-gray-800 p-4 md:p-6">
      <div class="flex justify-between mb-3">
        <div class="flex justify-center items-center">
          <h5 class="text-md leading-none text-gray-900 dark:text-white pe-1">
            <%= @title %>
          </h5>
        </div>
        <div>
          <button
            type="button"
            data-tooltip-target="data-tooltip"
            data-tooltip-placement="bottom"
            class="hidden sm:inline-flex items-center justify-center text-gray-500 w-8 h-8 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-700 focus:outline-none focus:ring-4 focus:ring-gray-200 dark:focus:ring-gray-700 rounded-lg text-sm"
          >
            <svg
              class="w-3.5 h-3.5"
              aria-hidden="true"
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 16 18"
            >
              <path
                stroke="currentColor"
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M8 1v11m0 0 4-4m-4 4L4 8m11 4v3a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2v-3"
              />
            </svg>
            <span class="sr-only">Download data</span>
          </button>
          <div
            id="data-tooltip"
            role="tooltip"
            class="absolute z-10 invisible inline-block px-3 py-2 text-sm font-medium text-white transition-opacity duration-300 bg-gray-900 rounded-lg shadow-sm opacity-0 tooltip dark:bg-gray-700"
          >
            Download CSV
            <div class="tooltip-arrow" data-popper-arrow></div>
          </div>
        </div>
      </div>

      <div
        class="py-6"
        id={@id}
        phx-hook="DonutChart"
        data-series={Jason.encode!(@dataset)}
        data-categories={Jason.encode!(@categories)}
      />
    </div>
    """
  end
end
