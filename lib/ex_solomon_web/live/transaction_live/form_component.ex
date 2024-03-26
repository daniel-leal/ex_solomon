defmodule ExSolomonWeb.TransactionLive.FormComponent do
  use ExSolomonWeb, :live_component

  alias ExSolomon.Transactions

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <div x-bind:class={"#{@transaction.is_revenue} || 'text-rose-500 dark:text-rose-400'"}>
          <%= @title %>
        </div>
        <:subtitle>Formulário de gerenciamento de transações.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="transaction-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
        x-data={@initialize_alpine}
      >
        <.input field={@form[:user_id]} type="hidden" />
        <.input field={@form[:is_revenue]} type="hidden" />

        <div class="xs:space-y-4 md:grid md:grid-cols-2 md:divide-x">
          <div class="md:pr-4 space-y-4">
            <.input field={@form[:description]} type="text" label="Descrição" />
            <.input field={@form[:amount]} type="money" label="Valor" />
            <.input
              field={@form[:category_id]}
              type="select"
              label="Categoria"
              prompt="selecione a categoria"
              options={Enum.map(@categories, &{&1.description, &1.id})}
            />
            <.input
              id="is_fixed"
              field={@form[:is_fixed]}
              type="checkbox"
              x-model="is_fixed"
              label="Recorrente"
            />
          </div>

          <div class="md:pl-4 space-y-4">
            <span x-show="is_fixed">
              <.input field={@form[:recurring_day]} type="number" label="Dia da recorrência" />
            </span>
            <span x-show="!is_fixed">
              <.input field={@form[:date]} type="date" label="Data" />
            </span>

            <.input
              field={@form[:kind]}
              type="select"
              label="Tipo"
              prompt="Selecione o tipo"
              options={Enum.map(@transaction_kinds, &{&1.description, &1.value})}
              x-model="kind"
            />

            <div x-show="kind == 'credit'">
              <.input
                field={@form[:credit_card_id]}
                type="select"
                label="Cartão de crédito"
                prompt="Selecione o cartão"
                options={Enum.map(@credit_cards, &{&1.name, &1.id})}
              />
            </div>
          </div>
        </div>

        <:actions>
          <.button phx-disable-with="Salvando...">Salvar transação</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{transaction: transaction} = assigns, socket) do
    changeset = Transactions.change_transaction(transaction)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)
     |> initialize_alpine(changeset)}
  end

  @impl true
  def handle_event("validate", %{"transaction" => transaction_params}, socket) do
    changeset =
      socket.assigns.transaction
      |> Transactions.change_transaction(transaction_params)
      |> Map.put(:action, :validate)

    socket
    |> assign_form(changeset)

    {:noreply, socket}
  end

  def handle_event("save", %{"transaction" => transaction_params}, socket) do
    save_transaction(socket, socket.assigns.action, transaction_params)
  end

  defp save_transaction(socket, :new, transaction_params) do
    case Transactions.create_transaction(transaction_params) do
      {:ok, transaction} ->
        notify_parent({:saved, transaction})

        {:noreply,
         socket
         |> put_flash(:info, "Transação incluída com sucesso!")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp initialize_alpine(socket, %Ecto.Changeset{} = changeset) do
    alpine_data = "{ is_fixed: #{changeset.data.is_fixed}, kind: '#{changeset.data.kind}' }"
    assign(socket, :initialize_alpine, alpine_data)
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
