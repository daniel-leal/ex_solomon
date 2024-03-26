defmodule ExSolomonWeb.TransactionLive.FilterComponent do
  use ExSolomonWeb, :live_component
  alias ExSolomon.Utils

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form for={@form} phx-target={@myself} phx-submit="filter">
        <div class="grid grid-cols-8 gap-4">
          <div class="col-span-2">
            <div
              id="daterangepicker"
              date-rangepicker
              class="grid grid-cols-2 gap-4"
              phx-hook="DateRangePicker"
            >
              <.input field={@form[:date_gte]} label="Data Início" />
              <.input field={@form[:date_lte]} label="Data Término" />
            </div>
          </div>

          <.input
            field={@form[:is_fixed]}
            type="select"
            label="Recorrência"
            prompt="Selecione a recorrência"
            options={[Recorrente: "true", Casual: "false"]}
          />

          <.input
            field={@form[:is_revenue]}
            type="select"
            label="Classificação"
            prompt="Selecione a classificação"
            options={[Receita: "true", Despesa: "false"]}
          />

          <.input
            field={@form[:category_id]}
            type="select"
            label="Categoria"
            prompt="selecione a categoria"
            options={Enum.map(@categories, &{&1.description, &1.id})}
          />

          <.input
            field={@form[:kind]}
            type="select"
            label="Tipo"
            prompt="Selecione o tipo"
            options={Enum.map(@transaction_kinds, &{&1.description, &1.value})}
          />

          <.input
            field={@form[:credit_card_id]}
            type="select"
            label="Cartão de crédito"
            prompt="selecione o cartão"
            options={Enum.map(@credit_cards, &{&1.name, &1.id})}
          />

          <div class="flex items-end gap-4">
            <button
              type="submit"
              class={[
                "flex flex-row items-center justify-center text-white w-full text-sm font-medium rounded-lg",
                "py-2.5 bg-violet-700 hover:bg-violet-800 focus:ring-4 focus:ring-violet-300",
                "dark:bg-violet-600 dark:hover:bg-violet-700 focus:outline-none dark:focus:ring-violet-800 "
              ]}
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="2"
                stroke-linecap="round"
                stroke-linejoin="round"
                class="lucide lucide-search h-4 w-4 mr-2"
              >
                <circle cx="11" cy="11" r="8" /><path d="m21 21-4.3-4.3" />
              </svg>
              Filtrar
            </button>
            <button
              type="button"
              class={[
                "flex flex-row items-center justify-center w-full py-2.5 focus:outline-none font-medium rounded-lg text-sm",
                "text-gray-900",
                "bg-white border border-zinc-300 hover:bg-zinc-100 focus:ring-4 focus:ring-zinc-100",
                "dark:bg-zinc-800 dark:text-white dark:border-zinc-600 dark:hover:bg-zinc-700",
                "dark:hover:border-zinc-600 dark:focus:ring-zinc-700"
              ]}
              phx-target={@myself}
              phx-click="clear"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="2"
                stroke-linecap="round"
                stroke-linejoin="round"
                class="lucide lucide-filter-x mr-2 h-4 w-4"
              >
                <path d="M13.013 3H2l8 9.46V19l4 2v-8.54l.9-1.055" /><path d="m22 3-5 5" /><path d="m17 3 5 5" />
              </svg>
              Limpar
            </button>
          </div>
        </div>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{filters: filters} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(filters)}
  end

  @impl true
  def handle_event("filter", params, socket) do
    do_filter(socket, params)
  end

  @impl true
  def handle_event("clear", _value, socket) do
    filters =
      socket
      |> Map.get(:assigns)
      |> Map.get(:filters)
      |> Enum.reduce(%{}, fn {key, _value}, acc -> Map.put(acc, key, "") end)

    socket
    |> assign_form(filters)
    |> do_filter(filters)
  end

  defp do_filter(socket, params) do
    socket = assign(socket, :filters, params)
    notify_parent({:filtered, params})
    {:noreply, socket}
  end

  defp assign_form(socket, filter_params) do
    assign(socket, :form, to_form(Utils.convert_to_string_keys(filter_params)))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
