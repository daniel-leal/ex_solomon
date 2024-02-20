defmodule ExSolomonWeb.Buttons do
  use Phoenix.Component

  attr :id, :any, default: "dropdownButton"
  attr :class, :string, default: nil
  slot :inner_block, required: true

  slot :dropdown_row, required: true do
    attr :label, :string, required: true, doc: "Name of the button row item"
    attr :action, :any, required: true, doc: "The action of button row"
  end

  def dropdown_button(assigns) do
    ~H"""
    <button
      id={@id}
      data-dropdown-toggle="dropdown"
      class="text-white bg-zinc-700 hover:bg-zinc-800 focus:ring-4 focus:outline-none focus:ring-zinc-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center inline-flex items-center dark:bg-zinc-600 dark:hover:bg-zinc-700 dark:focus:ring-zinc-800 #{@class}"
      type="button"
    >
      <%= render_slot(@inner_block) %>
      <svg
        class="w-2.5 h-2.5 ms-3"
        aria-hidden="true"
        xmlns="http://www.w3.org/2000/svg"
        fill="none"
        viewBox="0 0 10 6"
      >
        <path
          stroke="currentColor"
          stroke-linecap="round"
          stroke-linejoin="round"
          stroke-width="2"
          d="m1 1 4 4 4-4"
        />
      </svg>
    </button>
    <div
      id="dropdown"
      class="z-10 hidden bg-white divide-y divide-gray-100 rounded-lg shadow w-44 dark:bg-gray-700"
    >
      <ul
        class="py-2 text-sm text-gray-700 dark:text-gray-200"
        aria-labelledby="dropdownDefaultButton"
      >
        <li :for={row <- @dropdown_row}>
          <.link
            patch={row[:action]}
            class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
          >
            <%= row[:label] %>
          </.link>
        </li>
      </ul>
    </div>
    """
  end
end
