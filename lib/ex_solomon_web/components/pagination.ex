defmodule ExSolomonWeb.Pagination do
  use Phoenix.Component

  attr :id, :any, default: "pagination"
  attr :page_size, :integer, default: 10
  attr :page_number, :integer, required: true
  attr :total_pages, :integer, required: true
  attr :total_entries, :integer, required: true

  def page_navigation(assigns) do
    ~H"""
    <div class="flex items-center justify-between mt-6">
      <div class="flex flex-row items-center gap-2">
        Listando
        <form phx-change="change_page_size">
          <select
            id="page_size"
            name="page_size"
            class={[
              "bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-emerald-500",
              "focus:border-emerald-500 block w-full p-2.5",
              "dark:bg-zinc-700 dark:border-zinc-600",
              "dark:placeholder-zinc-400 dark:text-white dark:focus:ring-emerald-500 dark:focus:border-emerald-500"
            ]}
            phx-change="change_page_size"
          >
            <%= Phoenix.HTML.Form.options_for_select(
              ["5": 5, "10": 10, "15": 15, "30": 30],
              @page_size
            ) %>
          </select>
        </form>
        items
      </div>

      <nav aria-label="Page navigation" id={@id}>
        <ul class="inline-flex -space-x-px text-base h-10 cursor-pointer">
          <li>
            <a
              :if={@page_number <= 1}
              class={[
                "flex items-center justify-center px-4 h-10 ms-0 leading-tight text-zinc-500 bg-white cursor-not-allowed",
                "border border-e-0 border-zinc-300 rounded-s-lg opacity-60",
                "dark:bg-zinc-800 dark:border-zinc-700 dark:text-zinc-400"
              ]}
            >
              <svg
                class="w-3.5 h-3.5 me-2 rtl:rotate-180"
                aria-hidden="true"
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 14 10"
              >
                <path
                  stroke="currentColor"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M13 5H1m0 0 4 4M1 5l4-4"
                />
              </svg>
              Anterior
            </a>
            <a
              :if={@page_number > 1}
              class={[
                "flex items-center justify-center px-4 h-10 ms-0 leading-tight text-zinc-500 bg-white",
                "border border-e-0 border-zinc-300 rounded-s-lg hover:bg-zinc-100 hover:text-zinc-700",
                "dark:bg-zinc-800 dark:border-zinc-700 dark:text-zinc-400 dark:hover:bg-zinc-700 dark:hover:text-white"
              ]}
              phx-click="nav"
              phx-value-page={@page_number - 1}
            >
              <svg
                class="w-3.5 h-3.5 me-2 rtl:rotate-180"
                aria-hidden="true"
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 14 10"
              >
                <path
                  stroke="currentColor"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M13 5H1m0 0 4 4M1 5l4-4"
                />
              </svg>
              Anterior
            </a>
          </li>

          <%= for idx <- Enum.to_list(1..@total_pages) do %>
            <li>
              <a
                class={[
                  "flex items-center justify-center px-4 h-10 border",
                  idx != @page_number &&
                    "leading-tight text-zinc-500 bg-white border-zinc-300 hover:bg-zinc-100 hover:text-zinc-700 dark:bg-zinc-800 dark:border-zinc-700 dark:text-zinc-400 dark:hover:bg-zinc-700 dark:hover:text-white",
                  idx == @page_number &&
                    "text-emerald-600 bg-emerald-50 border-zinc-300 hover:bg-emerald-100 hover:text-emerald-700 dark:border-zinc-700 dark:bg-zinc-700 dark:text-white"
                ]}
                phx-click="nav"
                phx-value-page={idx}
              >
                <%= idx %>
              </a>
            </li>
          <% end %>

          <li>
            <a
              :if={@page_number >= @total_pages}
              class={[
                "flex items-center justify-center px-4 h-10 leading-tight text-zinc-500 bg-white",
                "border border-zinc-300 rounded-e-lg opacity-60 cursor-not-allowed",
                "dark:bg-zinc-800 dark:border-zinc-700 dark:text-zinc-400"
              ]}
            >
              Próximo
              <svg
                class="w-3.5 h-3.5 ms-2 rtl:rotate-180"
                aria-hidden="true"
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 14 10"
              >
                <path
                  stroke="currentColor"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M1 5h12m0 0L9 1m4 4L9 9"
                />
              </svg>
            </a>
            <a
              :if={@page_number < @total_pages}
              class={[
                "flex items-center justify-center px-4 h-10 leading-tight text-zinc-500 bg-white",
                "border border-zinc-300 rounded-e-lg hover:bg-zinc-100 hover:text-zinc-700",
                "dark:bg-zinc-800 dark:border-zinc-700 dark:text-zinc-400 dark:hover:bg-zinc-700 dark:hover:text-white"
              ]}
              phx-click="nav"
              phx-value-page={@page_number + 1}
            >
              Próximo
              <svg
                class="w-3.5 h-3.5 ms-2 rtl:rotate-180"
                aria-hidden="true"
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 14 10"
              >
                <path
                  stroke="currentColor"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M1 5h12m0 0L9 1m4 4L9 9"
                />
              </svg>
            </a>
          </li>
        </ul>
      </nav>

      <div class="text-wrap">
        <p>Total de <%= @total_entries %> registros</p>
      </div>
    </div>
    """
  end
end
