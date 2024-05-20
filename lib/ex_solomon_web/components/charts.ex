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
    <div class="w-full bg-white rounded-lg shadow dark:bg-gray-800 p-4 md:p-6 md:col-span-2 lg:col-span-2">
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
