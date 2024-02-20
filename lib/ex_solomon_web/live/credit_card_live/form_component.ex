defmodule ExSolomonWeb.CreditCardLive.FormComponent do
  use ExSolomonWeb, :live_component

  alias ExSolomon.CreditCards

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage credit_card records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="credit_card-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:limit]} type="text" label="Limit" />
        <.input field={@form[:invoice_start_day]} type="number" label="Invoice start day" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Credit card</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{credit_card: credit_card} = assigns, socket) do
    changeset = CreditCards.change_credit_card(credit_card)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"credit_card" => credit_card_params}, socket) do
    changeset =
      socket.assigns.credit_card
      |> CreditCards.change_credit_card(credit_card_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"credit_card" => credit_card_params}, socket) do
    save_credit_card(socket, socket.assigns.action, credit_card_params)
  end

  defp save_credit_card(socket, :edit, credit_card_params) do
    case CreditCards.update_credit_card(socket.assigns.credit_card, credit_card_params) do
      {:ok, credit_card} ->
        notify_parent({:saved, credit_card})

        {:noreply,
         socket
         |> put_flash(:info, "Credit card updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_credit_card(socket, :new, credit_card_params) do
    case CreditCards.create_credit_card(credit_card_params) do
      {:ok, credit_card} ->
        notify_parent({:saved, credit_card})

        {:noreply,
         socket
         |> put_flash(:info, "Credit card created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
